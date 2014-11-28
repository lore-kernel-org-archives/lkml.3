Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaK1Ieh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 03:34:37 -0500
Received: from mail-bl2on0061.outbound.protection.outlook.com ([65.55.169.61]:42560
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750902AbaK1Ief (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 03:34:35 -0500
X-Greylist: delayed 63130 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Nov 2014 03:34:35 EST
Date: Fri, 28 Nov 2014 09:34:24 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        <dougthompson@xmission.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        <michal.simek@xilinx.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>, <bp@alien8.de>
CC: <kpc528@gmail.com>, <kalluripunnaiahchoudary@gmail.com>,
        <punnaia@xilinx.com>
Subject: Re: [PATCH v5 1/2] Documentation: devicetree: Add ECC information
 to synopsys ddr controller
References: <1417101454-26361-1-git-send-email-punnaia@xilinx.com>
In-Reply-To: <1417101454-26361-1-git-send-email-punnaia@xilinx.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21136.004
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <5d58678ae1b84f40b6c8247a17cf1ee5@BN1AFFO11FD052.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51704005)(189002)(377454003)(479174003)(24454002)(164054003)(199003)(86362001)(74316001)(19580395003)(104016003)(23746002)(50466002)(21056001)(76176999)(54356999)(106466001)(107046002)(102836001)(120916001)(44976005)(62966003)(20776003)(99396003)(108616004)(33646002)(19580405001)(46102003)(95666004)(92566001)(4396001)(64706001)(83506001)(87936001)(65956001)(77156002)(6806004)(50986999)(31966008)(47776003)(65806001)(2201001)(65826006)(921003)(1121002)(107986001)(24736002)(2101003)(83996005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB028;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB028;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB028;
X-Forefront-PRVS: 04097B7F7F
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB028;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2014 04:17 PM, Punnaiah Choudary Kalluri wrote:
> Add ECC information to synopsys ddr memory controller.
> 
> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
> ---
>  .../bindings/memory-controllers/synopsys.txt       |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/memory-controllers/synopsys.txt b/Documentation/devicetree/bindings/memory-controllers/synopsys.txt
> index f9c6454..a43d26d 100644
> --- a/Documentation/devicetree/bindings/memory-controllers/synopsys.txt
> +++ b/Documentation/devicetree/bindings/memory-controllers/synopsys.txt
> @@ -1,5 +1,9 @@
>  Binding for Synopsys IntelliDDR Multi Protocol Memory Controller
>  
> +This controller has an optional ECC support in half-bus width (16-bit)
> +configuration. The ECC controller corrects one bit error and detects
> +two bit errors.
> +
>  Required properties:
>   - compatible: Should be 'xlnx,zynq-ddrc-a05'
>   - reg: Base address and size of the controllers memory area
> 

Acked-by: Michal Simek <michal.simek@xilinx.com>

Thanks,
Michal
