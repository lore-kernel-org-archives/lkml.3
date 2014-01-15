Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaAORUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:20:32 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35628 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752542AbaAORUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:20:30 -0500
Date: Wed, 15 Jan 2014 17:20:05 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Carino <marc.ceeeee@gmail.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] ARM: brcmstb: gic: add compatible string for
 Broadcom Brahma15
Message-ID: <20140115172005.GL25824@e106331-lin.cambridge.arm.com>
References: <1389743333-16741-1-git-send-email-marc.ceeeee@gmail.com>
 <1389743333-16741-7-git-send-email-marc.ceeeee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389743333-16741-7-git-send-email-marc.ceeeee@gmail.com>
Thread-Topic: [PATCH v3 6/7] ARM: brcmstb: gic: add compatible string for
 Broadcom Brahma15
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 11:48:52PM +0000, Marc Carino wrote:
> Document the Broadcom Brahma B15 GIC implementation as compatible
> with the ARM GIC standard.
> 
> Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Documentation/devicetree/bindings/arm/gic.txt |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
> index 3dfb0c0..b7d7970 100644
> --- a/Documentation/devicetree/bindings/arm/gic.txt
> +++ b/Documentation/devicetree/bindings/arm/gic.txt
> @@ -15,6 +15,7 @@ Main node required properties:
>  	"arm,cortex-a9-gic"
>  	"arm,cortex-a7-gic"
>  	"arm,arm11mp-gic"
> +	"brcm,brahma15-gic"

Similarly to the cpu binding patch, I think this should be
"brcm,brahma-b15-gic".

It doesn't have to be done here, but it might make sense to add
"arm,gic-v2" for arbitrary GICv2 implementations to use as a fallback
compatible string.

Cheers,
Mark.
