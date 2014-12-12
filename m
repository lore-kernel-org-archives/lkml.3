Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030862AbaLLQiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:38:10 -0500
Received: from mail-by2on0066.outbound.protection.outlook.com ([207.46.100.66]:22961
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030843AbaLLQiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:38:04 -0500
Date: Fri, 12 Dec 2014 08:37:53 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>
CC: Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-rockchip@lists.infradead.org>, <linux-sh@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 0/7] Pinctrl support for Zynq
References: <1d59c0972da04ec89dec6c09724986a1@BY2FFO11FD010.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1d59c0972da04ec89dec6c09724986a1@BY2FFO11FD010.protection.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21172.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <4d544fe425694a4e8043ddbf604db062@BN1AFFO11FD033.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(377424004)(24454002)(164054003)(51704005)(199003)(107046002)(106466001)(85202003)(15975445007)(33646002)(104016003)(31966008)(23676002)(74316001)(120916001)(21056001)(92726002)(54356999)(46102003)(62966003)(50466002)(4396001)(76176999)(77156002)(53416004)(85182001)(92566001)(64706001)(6806004)(108616004)(20776003)(19580405001)(99396003)(47776003)(83506001)(50986999)(86362001)(87936001)(19580395003)(107986001)(24736002)(23106004)(422495003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB051;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB051;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB051;
X-Forefront-PRVS: 04238CD941
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB051;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh, this went through the wrong SMTP. I suspect threading is broken
due to that. Let me know if you want me to resend this with intact
threading.
My apologies.

	Thanks,
	Sören

On Fri, 2014-12-12 at 08:34AM -0800, Soren Brinkmann wrote:
> Hi,
> 
> I made those few adjustments that came up in the v2 review. Other than
> those, these are the same patches as before.
> The series is based on pinctrl-v3.19-1, the current pinctrl/devel
> branch.
> A branch with these changes is available at
> https://github.com/sorenb-xlnx/linux-xlnx/commits/pinctrl
> 
> 	Thanks,
> 	Sören
> 
> Soren Brinkmann (7):
>   pinctrl: pinconf-generic: Infer map type from DT property
>   pinctrl: pinconf-generic: Allow driver to specify DT params
>   pinctrl: zynq: Document DT binding
>   pinctrl: Add driver for Zynq
>   ARM: zynq: Enable pinctrl
>   ARM: zynq: DT: Add pinctrl information
>   pinctrl: qcom-spmi-gpio: Migrate to pinconf-generic
> 
>  .../bindings/pinctrl/xlnx,zynq-pinctrl.txt         |  104 ++
>  arch/arm/boot/dts/zynq-7000.dtsi                   |    8 +-
>  arch/arm/boot/dts/zynq-zc702.dts                   |  181 +++
>  arch/arm/boot/dts/zynq-zc706.dts                   |  152 +++
>  arch/arm/mach-zynq/Kconfig                         |    2 +
>  drivers/pinctrl/Kconfig                            |    8 +
>  drivers/pinctrl/Makefile                           |    1 +
>  drivers/pinctrl/nomadik/pinctrl-abx500.c           |    2 +-
>  drivers/pinctrl/pinconf-generic.c                  |  199 ++--
>  drivers/pinctrl/pinconf.c                          |    4 +-
>  drivers/pinctrl/pinconf.h                          |   22 +-
>  drivers/pinctrl/pinctrl-rockchip.c                 |    2 +-
>  drivers/pinctrl/pinctrl-tz1090-pdc.c               |    2 +-
>  drivers/pinctrl/pinctrl-tz1090.c                   |    2 +-
>  drivers/pinctrl/pinctrl-zynq.c                     | 1176 ++++++++++++++++++++
>  drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |  125 +--
>  drivers/pinctrl/sh-pfc/pinctrl.c                   |    2 +-
>  include/linux/pinctrl/pinconf-generic.h            |   29 +
>  include/linux/pinctrl/pinctrl.h                    |    9 +
>  19 files changed, 1808 insertions(+), 222 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/xlnx,zynq-pinctrl.txt
>  create mode 100644 drivers/pinctrl/pinctrl-zynq.c
> 
> -- 
> 2.2.0.1.g9ee0458
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
