Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbbA0Ad3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:33:29 -0500
Received: from mail-bl2on0065.outbound.protection.outlook.com ([65.55.169.65]:57677
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754414AbbA0AdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:33:23 -0500
Date: Mon, 26 Jan 2015 16:32:55 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Heiko Stuebner <heiko@sntech.de>, <linux-sh@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Beniamino Galvani <b.galvani@gmail.com>,
        <linux-rockchip@lists.infradead.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH v4 6/7] ARM: zynq: DT: Add pinctrl information
References: <1420818231-13451-1-git-send-email-soren.brinkmann@xilinx.com>
 <1420818231-13451-7-git-send-email-soren.brinkmann@xilinx.com>
 <54C6D44C.4060106@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54C6D44C.4060106@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21286.003
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <db3077a2f9d8410f95cfd71f7e167494@BY2FFO11FD034.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; unipv.it; dkim=none (message not
 signed) header.d=none;
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(377424004)(51704005)(83506001)(19580395003)(110136001)(62966003)(85202003)(85182001)(53416004)(2950100001)(47776003)(77156002)(23676002)(46102003)(106466001)(54356999)(92566002)(50986999)(76176999)(6806004)(87936001)(86362001)(74316001)(104016003)(108616004)(92726002)(19580405001)(50466002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB025;H:xsj-pvapsmtpgw01;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB025;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2FFO11HUB025;
X-Forefront-PRVS: 046985391D
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB025;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2015 00:33:04.9327
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2FFO11HUB025
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB022;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-27 at 12:57AM +0100, Andreas Färber wrote:
> Am 09.01.2015 um 16:43 schrieb Soren Brinkmann:
> > Add pinctrl descriptions to the zc702 and zc706 device trees.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > Tested-by: Andreas Färber <afaerber@suse.de>
> > ---
> > Changes since v1:
> >  - remove 'pinctrl-' prefix for pinctrl sub-nodes
> >  - separate config and mux nodes
> > 
> > Changes since RFC v2:
> >  - add pinconf properties to zc702 mdio node
> >  - remove arguments from bias-related props
> > 
> > Changes since RFC v1:
> >  - separate DT changes into their own patch
> > ---
> >  arch/arm/boot/dts/zynq-7000.dtsi |   8 +-
> >  arch/arm/boot/dts/zynq-zc702.dts | 181 +++++++++++++++++++++++++++++++++++++++
> >  arch/arm/boot/dts/zynq-zc706.dts | 152 ++++++++++++++++++++++++++++++++
> >  3 files changed, 340 insertions(+), 1 deletion(-)
> [...]
> > diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
> > index 280f02dd4ddc..4995412f116f 100644
> > --- a/arch/arm/boot/dts/zynq-zc702.dts
> > +++ b/arch/arm/boot/dts/zynq-zc702.dts
> [...]
> > @@ -50,15 +52,24 @@
> >  	status = "okay";
> >  	phy-mode = "rgmii-id";
> >  	phy-handle = <&ethernet_phy>;
> > +	pinctrl-names = "default";
> > +	pinctrl-0 = <&pinctrl_gem0_default>;
> >  
> >  	ethernet_phy: ethernet-phy@7 {
> >  		reg = <7>;
> >  	};
> >  };
> >  
> > +&gpio0 {
> > +	pinctrl-names = "default";
> > +	pinctrl-0 = <&pinctrl_gpio0_default>;
> 
> On linux-next the equivalent no longer works for the Parallella, with
> gpio failing to probe.
> 
> If I move these two properties to the leds node (for which I am
> configuring gpio 7) then I get a heartbeat as before.

Moving this away from the gpio node seems wrong. IMHO, it should be
where it is. I guess, there might be some issues with probe
ordering/deferral that we may have to sort out.

	Sören
