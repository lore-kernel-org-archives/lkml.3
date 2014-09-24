Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaIXRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:09:26 -0400
Received: from mail-bl2on0070.outbound.protection.outlook.com ([65.55.169.70]:60370
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751133AbaIXRJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:09:24 -0400
Date: Wed, 24 Sep 2014 10:09:09 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: <linux-arm-kernel@lists.infradead.org>, <monstr@monstr.eu>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: zynq: DT: Add missing reference for ADC
References: <fced9e56dc4ef8df9ead34f6444c010cc31c7a61.1411567289.git.michal.simek@xilinx.com>
 <20140924161814.GG13679@xsjandreislx>
 <f6b47676-f664-4b01-8c70-a526eb8d1931@BY2FFO11FD011.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f6b47676-f664-4b01-8c70-a526eb8d1931@BY2FFO11FD011.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20972.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <6c7fde5f-aff1-41c1-8cde-b01b976aa9f3@BY2FFO11FD036.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377424004)(51704005)(24454002)(199003)(479174003)(377454003)(189002)(106466001)(107046002)(95666004)(85202003)(85852003)(83072002)(86362001)(23676002)(102836001)(53416004)(50986999)(76176999)(31966008)(77096002)(54356999)(21056001)(1496007)(92566001)(92726001)(44976005)(83322001)(50466002)(76482002)(19580405001)(79102003)(83506001)(46102003)(77982003)(81542003)(74662003)(74502003)(80022003)(81342003)(85306004)(87936001)(19580395003)(10300001)(31696002)(6806004)(110136001)(74316001)(99396003)(85182001)(64706001)(70736001)(4396001)(104016003)(90102001)(20776003)(120916001)(47776003)(107986001)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB041;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-24 at 07:06PM +0200, Michal Simek wrote:
> On 09/24/2014 06:18 PM, Sören Brinkmann wrote:
> > On Wed, 2014-09-24 at 04:01PM +0200, Michal Simek wrote:
> >> Add missing reference for ADC node.
> >>
> >> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> >> ---
> >>
> >>  arch/arm/boot/dts/zynq-7000.dtsi | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> >> index 772381fe07bb..fc90f47f9c03 100644
> >> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> >> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> >> @@ -64,7 +64,7 @@
> >>  		interrupt-parent = <&intc>;
> >>  		ranges;
> >>
> >> -		adc@f8007100 {
> >> +		adc: adc@f8007100 {
> > I think we enumerated all labels. I.e. 'adc0' is probably better.
> 
> I was thinking about it and the reason I didn't use that adc0 was
> that it is unique and it is just one in PS. Maybe there could be another adc in PL
> but it will be probably automated not to use adc key world.
> For PL part names was depending on user description.
> 
> Anyway logic was not to use enumerated label for unique IPs.
As you said yourself, due to having/being an FPGA and also the
extensibility of the platform via buses (including PCIe), I
would not consider any IP to be unique.

	Sören
