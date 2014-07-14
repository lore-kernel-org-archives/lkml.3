Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbaGNNfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:35:39 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:35380
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755068AbaGNNfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:35:30 -0400
Date: Mon, 14 Jul 2014 15:35:13 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Harini Katakam <harini.katakam@xilinx.com>, <wim@iguana.be>,
        <grant.likely@linaro.org>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>
CC: <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <harinikatakamlinux@gmail.com>, Harini Katakam <harinik@xilinx.com>
Subject: Re: [PATCH v3 2/2] devicetree: Add Cadence WDT devicetree bindings
 documentation
References: <1405340169-2820-1-git-send-email-harinik@xilinx.com>
 <1405340169-2820-2-git-send-email-harinik@xilinx.com>
In-Reply-To: <1405340169-2820-2-git-send-email-harinik@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <5af08174-4601-43dc-89f6-45ff57501df0@BN1BFFO11FD045.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(24454002)(51704005)(164054003)(377454003)(479174003)(189002)(199002)(47776003)(1496007)(33646001)(83322001)(6806004)(44976005)(81342001)(79102001)(95666004)(85306003)(4396001)(65956001)(77982001)(19580405001)(106466001)(70736001)(20776003)(107046002)(21056001)(87936001)(64706001)(99396002)(92726001)(2201001)(46102001)(50986999)(31696002)(86362001)(92566001)(81542001)(102836001)(76176999)(85852003)(80022001)(54356999)(74662001)(74316001)(64126003)(83072002)(50466002)(83506001)(76482001)(104016003)(74502001)(23756003)(19580395003)(31966008)(65826006)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB039;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02723F29C4
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 02:16 PM, Harini Katakam wrote:
> Add cadence-wdt bindings documentation.
> 
> Signed-off-by: Harini Katakam <harinik@xilinx.com>
> ---
> 
> v3 changes:
> - Change reset property type and improve description.
> - Improve description of clocks and interrupts.
> - Use watchdog@ in the example.
> - Use only cdns compatible string for now.
> 
> v2:
> No changes
> 
> ---
>  .../devicetree/bindings/watchdog/cadence-wdt.txt   |   27 ++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
> 
> diff --git a/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt b/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
> new file mode 100644
> index 0000000..ab23e38
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
> @@ -0,0 +1,27 @@
> +Zynq Watchdog Device Tree Bindings
> +-------------------------------------------
> +
> +Required properties:
> +- compatible		: Should be "cdns,wdt-r1p2".
> +- clocks		: Input clock specifier. This should be the ref clk.
> +- reg			: Physical base address and size of WDT registers map.
> +- interrupts		: Property with a value describing the interrupt
> +			  number. This interrupt is used for indication
> +			  when the watchdog times out.
> +- interrupt-parent	: Must be core interrupt controller.
> +
> +Optional properties
> +- reset			: If this property exists, then a reset is done
> +			  when watchdog times out.
> +- timeout-sec		: Watchdog timeout value (in seconds).
> +
> +Example:
> +	watchdog@f8005000 {
> +		compatible = "xlnx,zynq-wdt-r1p2";

According to description above - you should use cdns compatible string here too.

Thanks,
Michal

