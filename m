Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbbA0BU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:20:56 -0500
Received: from mail-bn1on0075.outbound.protection.outlook.com ([157.56.110.75]:22776
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932220AbbA0BUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:20:54 -0500
Date: Mon, 26 Jan 2015 17:20:48 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        <devicetree@vger.kernel.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Ola Jeppson <ola@adapteva.com>,
        <linux-gpio@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v3] ARM: zynq: DT: Add USB to device tree
References: <d78fedd84f354d80985187f851cb3cd1@BN1AFFO11FD055.protection.gbl>
 <54C5F89A.3090901@suse.de> <54C5F965.90100@monstr.eu>
 <54C5FBC3.7030903@suse.de> <54C60A56.7010403@suse.de>
 <c65880cef67945ebaf61306febc1349b@BN1BFFO11FD010.protection.gbl>
 <54C6698F.5020301@suse.de>
 <8f367d9b85924f8e9cc9cb6fdff9a054@BN1BFFO11FD040.protection.gbl>
 <bb50396a16ab4042bdb554f72bde0bf7@BL2FFO11FD023.protection.gbl>
 <54C6E672.4030602@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54C6E672.4030602@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21286.003
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <b9115b5a2a4f4cefa4a16721dd4ea3b2@BY2FFO11FD053.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; ti.com; dkim=none (message not
 signed) header.d=none;
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(479174004)(377454003)(377424004)(51704005)(46102003)(50986999)(6806004)(54356999)(2950100001)(85182001)(87936001)(83506001)(93886004)(92726002)(50466002)(104016003)(53416004)(23676002)(15975445007)(19580395003)(86362001)(92566002)(106466001)(110136001)(85202003)(76176999)(108616004)(62966003)(74316001)(77156002)(47776003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB055;H:xsj-pvapsmtpgw01;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB055;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2FFO11HUB055;
X-Forefront-PRVS: 046985391D
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB055;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2015 01:20:50.5620
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2FFO11HUB055
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-27 at 02:14AM +0100, Andreas Färber wrote:
> + linux-gpio, linux-usb, Felipe Balbi
> 
> Am 26.01.2015 um 19:44 schrieb Sören Brinkmann:
> > On Mon, 2015-01-26 at 08:23AM -0800, Sören Brinkmann wrote:
> >> On Mon, 2015-01-26 at 05:21PM +0100, Andreas Färber wrote:
> >>> Am 26.01.2015 um 16:50 schrieb Sören Brinkmann:
> >>>> On Mon, 2015-01-26 at 10:35AM +0100, Andreas Färber wrote:
> >>>>> Am 26.01.2015 um 09:33 schrieb Andreas Färber:
> >>>>>> Am 26.01.2015 um 09:23 schrieb Michal Simek:
> >>>>>>> On 01/26/2015 09:19 AM, Andreas Färber wrote:
> >>>>>>>> And if I apply it to my -next based tree, adding corresponding nodes to
> >>>>>>>> zynq-parallella.dts, I get repeatedly:
> >>>>>>>>
> >>>>>>>> [  +0,012242] ci_hdrc ci_hdrc.0: no of_node; not parsing pinctrl DT
> >>>>>>>> [  +0,000157] ci_hdrc ci_hdrc.0: ChipIdea HDRC found, lpm: 0; cap:
> >>>>>>>> f090e100 op: f090e140
> >>>>>>>> [  +0,000081] platform ci_hdrc.0: Driver ci_hdrc requests probe deferral
> >>>>>>>> [  +0,005360] ci_hdrc ci_hdrc.1: no of_node; not parsing pinctrl DT
> >>>>>>>> [  +0,000120] ci_hdrc ci_hdrc.1: ChipIdea HDRC found, lpm: 0; cap:
> >>>>>>>> f0910100 op: f0910140
> >>>>>>>> [  +0,001810] platform ci_hdrc.1: Driver ci_hdrc requests probe deferral
> >>>>>>>>
> >>>>>>>> Am I missing any other patches or config options?
> [...]
> >>>>>>> Why is it deferred? Is it because of pinmuxing stuff?
> >>>>>>
> >>>>>> No, happened without as well.
> >>>>>>
> >>>>>> Looking at a different place in dmesg, I spot this:
> >>>>>>
> >>>>>> [  +0,003988] usb_phy_generic phy0: GPIO lookup for consumer reset-gpios
> >>>>>> [  +0,000012] usb_phy_generic phy0: using device tree for GPIO lookup
> >>>>>> [  +0,000015] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpios'
> >>>>>> property
> >>>>>>  of node '/phy0[0]'
> >>>>>> [  +0,000013] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpio'
> >>>>>> property
> >>>>>> of node '/phy0[0]'
> >>>>>> [  +0,000010] usb_phy_generic phy0: using lookup tables for GPIO lookup
> >>>>>> [  +0,000153] usb_phy_generic phy0: lookup for GPIO reset-gpios failed
> >>>>>> [  +0,000012] usb_phy_generic phy0: Error requesting RESET GPIO
> >>>>>> [  +0,004360] usb_phy_generic: probe of phy0 failed with error -2
> >>>>>> [  +0,004991] usb_phy_generic phy1: GPIO lookup for consumer reset-gpios
> >>>>>> [  +0,000012] usb_phy_generic phy1: using device tree for GPIO lookup
> >>>>>> [  +0,000013] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpios'
> >>>>>> property
> >>>>>>  of node '/phy1[0]'
> >>>>>> [  +0,000013] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpio'
> >>>>>> property of node '/phy1[0]'
> >>>>>> [  +0,000010] usb_phy_generic phy1: using lookup tables for GPIO lookup
> >>>>>> [  +0,000012] usb_phy_generic phy1: lookup for GPIO reset-gpios failed
> >>>>>> [  +0,000011] usb_phy_generic phy1: Error requesting RESET GPIO
> >>>>>> [  +0,004337] usb_phy_generic: probe of phy1 failed with error -2
> >>>>>>
> >>>>>> So, I guess the chipidea driver is deferring because the phys want a
> >>>>>> property that neither me nor you are specifying? [...]
> [...]
> >>>>> In my manuals and notes I can't find any GPIO being used as reset for
> >>>>> the USB PHYs. Any thoughts appreciated.
> >>>>
> >>>> Such a connection is optional. The platform might rely on its reset
> >>>> circuit, though it might not work for warm reboots.
> >>>> I haven't looked at parallela docs, but if there is a schematic
> >>>> available, that should tell you if/what is connected to the PHY reset
> >>>> pin.
> >>>
> >>> I do have the schematic, and the way I read it, only the on-board reset
> >>> button resets the PHYs.
> >>>
> >>> Yet it looks as if usb-nop-xceiv insists on a reset-gpios above, no?
> >>> Does it work on your boards with linux-next?
> >>
> >> I haven't re-tested it since I submitted the patches, but at that time
> >> it worked. But I also didn't test USB with the pinctrl patches together.
> >> I'll do some testing later today.
> > 
> > So, just did a test. I took all the pinctrl stuff and this patch and ran
> > it on a zc702. I plugged in a thumb drive and that worked just fine. So,
> > basically this patch could go in, despite missing pinctrl properties.
> 
> For my board I needed the following workaround:
> 
> diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
> index dd05254241fb..96c7c36e22a6 100644
> --- a/drivers/usb/phy/phy-generic.c
> +++ b/drivers/usb/phy/phy-generic.c
> @@ -218,13 +218,13 @@ int usb_phy_gen_create_phy(struct device *dev,
> struct usb_phy_generic *nop,
>                         clk_rate = 0;
> 
>                 needs_vcc = of_property_read_bool(node, "vcc-supply");
> -               nop->gpiod_reset = devm_gpiod_get(dev, "reset-gpios");
> +               /*nop->gpiod_reset = devm_gpiod_get(dev, "reset-gpios");
>                 err = PTR_ERR(nop->gpiod_reset);
>                 if (!err) {
>                         nop->gpiod_vbus = devm_gpiod_get(dev,
> 
> "vbus-detect-gpio");
>                         err = PTR_ERR(nop->gpiod_vbus);
> -               }
> +               }*/
>         } else if (pdata) {
>                 type = pdata->type;
>                 clk_rate = pdata->clk_rate;
> 
> [  +0,004738] usb_phy_generic phy0: Looking up vcc-supply from device tree
> [  +0,000018] usb_phy_generic phy0: Looking up vcc-supply property in
> node /phy0 failed
> [  +0,000011] phy0 supply vcc not found, using dummy regulator
> [  +0,004844] usb_phy_generic phy1: Looking up vcc-supply from device tree
> [  +0,000017] usb_phy_generic phy1: Looking up vcc-supply property in
> node /phy1 failed
> [  +0,000008] phy1 supply vcc not found, using dummy regulator
> 
> Basically, usb-nop-xceiv fails to probe when reset-gpios property is
> absent (and probably also when vbus-detect-gpio property is absent).
> So I don't understand why it would work for your boards without such
> properties on today's linux-next... sounds like you tested a different tree?

I tested on the 3.19 tip, not on next. I see the problems you see on
next though. Haven't really dug deeper yet.

> 
> Take a look at __gpiod_get_index() called from devm_gpiod_get():
> http://lxr.free-electrons.com/source/drivers/gpio/gpiolib.c#L1648
> 
> !desc || desc == ERR_PTR(-ENOENT) results in the above "using lookup
> tables for GPIO lookup", then IS_ERR(desc) in "lookup for GPIO %s failed".
> 
> My interpretation is that this gpiolib code is probably okay but that
> the generic usb phy code fails to check for specific error codes such as
> absent property (as opposed to deferred resolution of a phandle, where
> we do want to return -EDEFER early).

Sounds like you're already close.

	Sören
