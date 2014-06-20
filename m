Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966554AbaFTAJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 20:09:37 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:11372 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966097AbaFTAJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 20:09:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqQGADR7o1Ol5H4J/2dsb2JhbABZiVS+NAGBIXWEAwEBBTo/EAsYCRUQD0gZiELNIReOEmQHFoQtBK4bg1QrgTE
From: Alistair Popple <alistair@popple.id.au>
To: benh@kernel.crashing.org
Cc: Paul Bolle <pebolle@tiscali.nl>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] IBM Akebono: Remove obsolete config select
Date: Fri, 20 Jun 2014 10:10 +1000
Message-ID: <1774195.a1B25gz7RT@mexican>
User-Agent: KMail/4.11.5 (Linux/3.11.0-17-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1402660592.28881.22.camel@x220>
References: <1398998002.2925.15.camel@pasglop> <1399018005-23136-1-git-send-email-alistair@popple.id.au> <1402660592.28881.22.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

It looks like we may have missed this trivial fix? Can you please apply it to 
your tree?

Regards,

Alistair

On Fri, 13 Jun 2014 13:56:32 Paul Bolle wrote:
> On Fri, 2014-05-02 at 18:06 +1000, Alistair Popple wrote:
> > The original implementation of MMC support for Akebono introduced a
> > new configuration symbol (MMC_SDHCI_OF_476GTR). This symbol has been
> > dropped in favour of using the generic platform driver however the
> > select for this symbol was mistakenly left in the platform
> > configuration.
> > 
> > This patch removes the obsolete symbol selection.
> > 
> > Signed-off-by: Alistair Popple <alistair@popple.id.au>
> 
> This patch hasn't yet entered linux-next nor Linus' tree. Is it queued
> somewhere? If not, would a
>     Acked-by: Paul Bolle <pebolle@tiscali.nl>
> 
> help to get this trivial patch queued for either of those trees?
> 
> 
> Paul Bolle
> 
> > ---
> > 
> >  arch/powerpc/platforms/44x/Kconfig | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/arch/powerpc/platforms/44x/Kconfig
> > b/arch/powerpc/platforms/44x/Kconfig index 8beec7d..908bf11 100644
> > --- a/arch/powerpc/platforms/44x/Kconfig
> > +++ b/arch/powerpc/platforms/44x/Kconfig
> > @@ -220,7 +220,6 @@ config AKEBONO
> > 
> >  	select USB_EHCI_HCD_PLATFORM
> >  	select MMC_SDHCI
> >  	select MMC_SDHCI_PLTFM
> > 
> > -	select MMC_SDHCI_OF_476GTR
> > 
> >  	select ATA
> >  	select SATA_AHCI_PLATFORM
> >  	help

