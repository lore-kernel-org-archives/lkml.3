Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaAOQ7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:59:03 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34937 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751959AbaAOQ66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:58:58 -0500
Date: Wed, 15 Jan 2014 16:58:26 +0000
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
Subject: Re: [PATCH v3 4/7] ARM: brcmstb: add CPU binding for Broadcom
 Brahma15
Message-ID: <20140115165825.GJ25824@e106331-lin.cambridge.arm.com>
References: <1389743333-16741-1-git-send-email-marc.ceeeee@gmail.com>
 <1389743333-16741-5-git-send-email-marc.ceeeee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389743333-16741-5-git-send-email-marc.ceeeee@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 11:48:50PM +0000, Marc Carino wrote:
> Add the Broadcom Brahma B15 CPU to the DT CPU binding list.
> 
> Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Documentation/devicetree/bindings/arm/cpus.txt |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
> index 9130435..423b879 100644
> --- a/Documentation/devicetree/bindings/arm/cpus.txt
> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> @@ -163,6 +163,7 @@ nodes to be present and contain the properties described below.
>  			    "arm,cortex-r4"
>  			    "arm,cortex-r5"
>  			    "arm,cortex-r7"
> +			    "brcm,brahma15"

Given all the documentation I can find online calls the CPU
"Brahma-B15", would it not make more sense for this to be
"brcm,brahma-b15"? 

That would match what we do for the ARM Cortex-[ar]\d processors.

Otherwise, this looks fine to me.

Cheers,
Mark.
