Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaDYPty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:49:54 -0400
Received: from mail-by2on0113.outbound.protection.outlook.com ([207.46.100.113]:46723
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751125AbaDYPtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:49:53 -0400
X-Greylist: delayed 61104 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Apr 2014 11:49:52 EDT
Message-ID: <1398440850.389.0.camel@linux-builds1>
Subject: Re: [PATCH 1/4] dt: bindings: Typo s/clocks-names/clock-names/g
From: Dinh Nguyen <dinguyen@altera.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
CC: Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        <netdev@vger.kernel.org>
Date: Fri, 25 Apr 2014 10:47:30 -0500
In-Reply-To: <1398192025-31523-1-git-send-email-geert+renesas@glider.be>
References: <1398192025-31523-1-git-send-email-geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(377424004)(51704005)(24454002)(164054003)(6806004)(83322001)(79102001)(19580405001)(44976005)(47776003)(20776003)(77156001)(19580395003)(77982001)(80976001)(33646001)(76482001)(33716001)(23676002)(31966008)(2009001)(74662001)(88136002)(74502001)(87936001)(81342001)(97736001)(83072002)(89996001)(85852003)(87286001)(84676001)(80022001)(92566001)(575784001)(93916002)(4396001)(92726001)(46102001)(62966002)(50466002)(50226001)(50986999)(86362001)(76176999)(81542001)(99396002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2FFO11HUB022;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:AF12F466.B1A34DCB.57558303.A092FA49.20214;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0192E812EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-22 at 20:40 +0200, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Dinh Nguyen <dinguyen@altera.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: netdev@vger.kernel.org
> ---
>  .../devicetree/bindings/net/socfpga-dwmac.txt      |    2 +-
>  Documentation/devicetree/bindings/net/stmmac.txt   |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/socfpga-dwmac.txt b/Documentation/devicetree/bindings/net/socfpga-dwmac.txt
> index 636f0ac4e223..2a60cd3e8d5d 100644
> --- a/Documentation/devicetree/bindings/net/socfpga-dwmac.txt
> +++ b/Documentation/devicetree/bindings/net/socfpga-dwmac.txt
> @@ -23,5 +23,5 @@ gmac0: ethernet@ff700000 {
>  	interrupt-names = "macirq";
>  	mac-address = [00 00 00 00 00 00];/* Filled in by U-Boot */
>  	clocks = <&emac_0_clk>;
> -	clocks-names = "stmmaceth";
> +	clock-names = "stmmaceth";
>  };
> diff --git a/Documentation/devicetree/bindings/net/stmmac.txt b/Documentation/devicetree/bindings/net/stmmac.txt
> index 80c1fb8bfbb8..a2acd2b26baf 100644
> --- a/Documentation/devicetree/bindings/net/stmmac.txt
> +++ b/Documentation/devicetree/bindings/net/stmmac.txt
> @@ -33,7 +33,7 @@ Optional properties:
>  - max-frame-size: See ethernet.txt file in the same directory
>  - clocks: If present, the first clock should be the GMAC main clock,
>    further clocks may be specified in derived bindings.
> -- clocks-names: One name for each entry in the clocks property, the
> +- clock-names: One name for each entry in the clocks property, the
>    first one should be "stmmaceth".
>  
>  Examples:

I've applied this patch to git.rocketboards.org/linux-socfpga-next.git
next-dt.

Thanks,
Dinh


