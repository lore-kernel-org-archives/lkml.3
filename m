Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbbAZSoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 13:44:16 -0500
Received: from mail-bn1bon0073.outbound.protection.outlook.com ([157.56.111.73]:40384
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753521AbbAZSoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 13:44:12 -0500
Date: Mon, 26 Jan 2015 10:44:03 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        <devicetree@vger.kernel.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Ola Jeppson <ola@adapteva.com>
Subject: Re: [PATCH v3] ARM: zynq: DT: Add USB to device tree
References: <1417536431-27759-1-git-send-email-soren.brinkmann@xilinx.com>
 <d78fedd84f354d80985187f851cb3cd1@BN1AFFO11FD055.protection.gbl>
 <54C5F89A.3090901@suse.de> <54C5F965.90100@monstr.eu>
 <54C5FBC3.7030903@suse.de> <54C60A56.7010403@suse.de>
 <c65880cef67945ebaf61306febc1349b@BN1BFFO11FD010.protection.gbl>
 <54C6698F.5020301@suse.de>
 <8f367d9b85924f8e9cc9cb6fdff9a054@BN1BFFO11FD040.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8f367d9b85924f8e9cc9cb6fdff9a054@BN1BFFO11FD040.protection.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21286.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <bb50396a16ab4042bdb554f72bde0bf7@BL2FFO11FD023.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; adapteva.com; dkim=none (message
 not signed) header.d=none;
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(51704005)(377454003)(377424004)(479174004)(164054003)(86362001)(92566002)(87936001)(19580395003)(46102003)(50466002)(85182001)(50986999)(76176999)(6806004)(108616004)(74316001)(92726002)(53416004)(110136001)(47776003)(104016003)(85202003)(2950100001)(83506001)(106466001)(93886004)(54356999)(62966003)(77156002)(23676002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB021;H:xsj-pvapsmtpgw01;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB021;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2FFO11HUB021;
X-Forefront-PRVS: 0468FE4A2B
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB021;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2015 18:44:10.7628
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2FFO11HUB021
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-26 at 08:23AM -0800, Sören Brinkmann wrote:
> On Mon, 2015-01-26 at 05:21PM +0100, Andreas Färber wrote:
> > Am 26.01.2015 um 16:50 schrieb Sören Brinkmann:
> > > On Mon, 2015-01-26 at 10:35AM +0100, Andreas Färber wrote:
> > >> Am 26.01.2015 um 09:33 schrieb Andreas Färber:
> > >>> Am 26.01.2015 um 09:23 schrieb Michal Simek:
> > >>>> On 01/26/2015 09:19 AM, Andreas Färber wrote:
> > >>>>> And if I apply it to my -next based tree, adding corresponding nodes to
> > >>>>> zynq-parallella.dts, I get repeatedly:
> > >>>>>
> > >>>>> [  +0,012242] ci_hdrc ci_hdrc.0: no of_node; not parsing pinctrl DT
> > >>>>> [  +0,000157] ci_hdrc ci_hdrc.0: ChipIdea HDRC found, lpm: 0; cap:
> > >>>>> f090e100 op: f090e140
> > >>>>> [  +0,000081] platform ci_hdrc.0: Driver ci_hdrc requests probe deferral
> > >>>>> [  +0,005360] ci_hdrc ci_hdrc.1: no of_node; not parsing pinctrl DT
> > >>>>> [  +0,000120] ci_hdrc ci_hdrc.1: ChipIdea HDRC found, lpm: 0; cap:
> > >>>>> f0910100 op: f0910140
> > >>>>> [  +0,001810] platform ci_hdrc.1: Driver ci_hdrc requests probe deferral
> > >>>>>
> > >>>>> Am I missing any other patches or config options?
> > >>>>> (I do notice that the pinctrl v3 patch that got merged has a trivial bug
> > >>>>> for usb0, for which I'll send a patch later on.)
> > >>>>
> > >>>> Why is it deferred? Is it because of pinmuxing stuff?
> > >>>
> > >>> No, happened without as well.
> > >>>
> > >>> Looking at a different place in dmesg, I spot this:
> > >>>
> > >>> [  +0,003988] usb_phy_generic phy0: GPIO lookup for consumer reset-gpios
> > >>> [  +0,000012] usb_phy_generic phy0: using device tree for GPIO lookup
> > >>> [  +0,000015] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpios'
> > >>> property
> > >>>  of node '/phy0[0]'
> > >>> [  +0,000013] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpio'
> > >>> property
> > >>> of node '/phy0[0]'
> > >>> [  +0,000010] usb_phy_generic phy0: using lookup tables for GPIO lookup
> > >>> [  +0,000153] usb_phy_generic phy0: lookup for GPIO reset-gpios failed
> > >>> [  +0,000012] usb_phy_generic phy0: Error requesting RESET GPIO
> > >>> [  +0,004360] usb_phy_generic: probe of phy0 failed with error -2
> > >>> [  +0,004991] usb_phy_generic phy1: GPIO lookup for consumer reset-gpios
> > >>> [  +0,000012] usb_phy_generic phy1: using device tree for GPIO lookup
> > >>> [  +0,000013] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpios'
> > >>> property
> > >>>  of node '/phy1[0]'
> > >>> [  +0,000013] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpio'
> > >>> property of node '/phy1[0]'
> > >>> [  +0,000010] usb_phy_generic phy1: using lookup tables for GPIO lookup
> > >>> [  +0,000012] usb_phy_generic phy1: lookup for GPIO reset-gpios failed
> > >>> [  +0,000011] usb_phy_generic phy1: Error requesting RESET GPIO
> > >>> [  +0,004337] usb_phy_generic: probe of phy1 failed with error -2
> > >>>
> > >>> So, I guess the chipidea driver is deferring because the phys want a
> > >>> property that neither me nor you are specifying? Would that be the two
> > >>> MDIO pins 52 and 53 that would need to be specified?
> > >>
> > >> Erm, scratch that last question - wrong PHY. Trying it resolved the
> > >> above phy errors but not the original problem. And so does an empty one:
> > >>
> > >> @@ -99,11 +100,13 @@
> > >>
> > >>         usb_phy0: phy0 {
> > >>                 compatible = "usb-nop-xceiv";
> > >> +               reset-gpios = <>;
> > >>                 #phy-cells = <0>;
> > >>         };
> > >>
> > >>         usb_phy1: phy1 {
> > >>                 compatible = "usb-nop-xceiv";
> > >> +               reset-gpios = <>;
> > >>                 #phy-cells = <0>;
> > >>         };
> > >>  };
> > >>
> > >> In my manuals and notes I can't find any GPIO being used as reset for
> > >> the USB PHYs. Any thoughts appreciated.
> > > 
> > > Such a connection is optional. The platform might rely on its reset
> > > circuit, though it might not work for warm reboots.
> > > I haven't looked at parallela docs, but if there is a schematic
> > > available, that should tell you if/what is connected to the PHY reset
> > > pin.
> > 
> > I do have the schematic, and the way I read it, only the on-board reset
> > button resets the PHYs.
> > 
> > Yet it looks as if usb-nop-xceiv insists on a reset-gpios above, no?
> > Does it work on your boards with linux-next?
> 
> I haven't re-tested it since I submitted the patches, but at that time
> it worked. But I also didn't test USB with the pinctrl patches together.
> I'll do some testing later today.

So, just did a test. I took all the pinctrl stuff and this patch and ran
it on a zc702. I plugged in a thumb drive and that worked just fine. So,
basically this patch could go in, despite missing pinctrl properties.

Michal: How do you wanna handle this? Could you create a branch that has
all the DT updates I can base stuff on, please? We could either take the
pinctrl patches and this patch and add another one adding the pinctrl
properties to the USB nodes. Or leave this patch out for now and revise
it on top of the pinctrl patches.

	Thanks,
	Sören
