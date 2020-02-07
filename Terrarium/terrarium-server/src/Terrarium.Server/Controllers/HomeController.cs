using System.Data.Entity;
using System.Web.Mvc;
using Terrarium.Server.DataModels;
using Terrarium.Server.Models;
using Terrarium.Server.Repositories;
using Terrarium.Server.ViewModels;

namespace Terrarium.Server.Controllers
{
    public class HomeController : Controller
    {
        private readonly ITipRepository _tipRepository;
        private readonly IUsageRepository _usageRepository;

        public HomeController(ITipRepository tipRepository, IUsageRepository usageRepository)
        {
            _tipRepository = tipRepository;
            _usageRepository = usageRepository;
        }

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Charts()
        {
            return View();
        }

        public ActionResult Usage()
        {
            var alias = Request.QueryString["Alias"] ?? User.Identity.Name;

            var vm = new UsageViewModel
            {
                UserAliasLabel = alias,
                UserTodayLabel = _usageRepository.GetUserUsage(alias, UsagePeriod.Today).TotalHours + " hours",
                UserWeekLabel = _usageRepository.GetUserUsage(alias, UsagePeriod.Week).TotalHours + " hours",
                UserTotalLabel = _usageRepository.GetUserUsage(alias, UsagePeriod.Total).TotalHours + " hours"
            };

            return View(vm);
        }

        public ActionResult RandomTip()
        {
            var tip = _tipRepository.GetRandomTip();
            return PartialView("_RandomTips", new RandomTipViewModel {Tip = tip.Tip});
        }

        public ActionResult ServerStatus()
        {
            // hack fix me
            var api = new PeerDiscoveryController(new TerrariumDbContext());

            var vm = new ServerStatusViewModel
            {
                IsDatabaseUp = Database.Exists("TerrariumDbContext"),
                PeerCount = api.GetNumPeers("", "")
            };

            return PartialView("_ServerStatus", vm);
        }

        public ActionResult TopCritters()
        {
            return PartialView("_TopCritters");
        }
    }
}
