Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaIXJkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:40:06 -0400
Received: from mail-bn1on0066.outbound.protection.outlook.com ([157.56.110.66]:47481
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751601AbaIXJkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:40:02 -0400
Date: Wed, 24 Sep 2014 11:39:46 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH] ARM: zynq: DT: Remove 222 MHz OPP
References: <1411498520-8117-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1411498520-8117-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20950.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <b5cd2f8d-f37d-4e19-a891-bd234849096d@BL2FFO11FD054.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(51704005)(24454002)(377454003)(199003)(479174003)(164054003)(23746002)(65806001)(83506001)(4396001)(19580405001)(65956001)(64706001)(20776003)(90102001)(21056001)(99396003)(19580395003)(95666004)(104016003)(31966008)(6806004)(44976005)(74316001)(83322001)(106466001)(47776003)(1496007)(10300001)(50466002)(120916001)(107046002)(102836001)(80022003)(85306004)(50986999)(54356999)(76176999)(76482002)(64126003)(31696002)(92726001)(86362001)(92566001)(79102003)(81542003)(70736001)(83072002)(575784001)(74662003)(77982003)(74502003)(81342003)(85852003)(46102003)(87936001)(65826006)(107986001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB031;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 08:55 PM, Soren Brinkmann wrote:
> Due to dependencies between timer and CPU frequency, only changes by
> powers of two are allowed. The clocksource driver prevents other
> changes, but with cpufreq and its governors it can result in being
> spammed with error messages constantly. Hence, remove the 222 MHz OPP.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index 6cc83d4c6c76..a0ed01d68328 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -30,7 +30,6 @@
>  				/* kHz    uV */
>  				666667  1000000
>  				333334  1000000
> -				222223  1000000
>  			>;
>  		};
>  
> 

Applied.

Thanks,
Michal
