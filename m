Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbaEBCdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 22:33:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:36478 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbaEBCds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 22:33:48 -0400
Message-ID: <1398998002.2925.15.camel@pasglop>
Subject: Re: [4/5] IBM Akebono: Add the Akebono platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alistair Popple <alistair@popple.id.au>
Cc: Paul Bolle <pebolle@tiscali.nl>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Date: Fri, 02 May 2014 12:33:22 +1000
In-Reply-To: <10214508.Vq3Ynjy2Co@mexican>
References: <1394077948-8395-5-git-send-email-alistair@popple.id.au>
	 <1398936447.4121.12.camel@x220> <10214508.Vq3Ynjy2Co@mexican>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-02 at 10:35 +1000, Alistair Popple wrote:

> > The plan to add MMC_SDHCI_OF_476GTR seems to have been abandoned (see
> > the discussion of https://lkml.org/lkml/2014/2/21/24 ). So this select
> > is not needed. Should I submit a trivial patch to drop this select?
> 
> Thanks for pointing this out, I should have removed the select for 
> MMC_SDHCI_OF_476GTR as suggested. I can submit a patch to drop the select or 
> send an updated version of the original patch. Which is easiest for you Ben?

I don't rebase next so it has to be a followup patch.

Cheers,
Ben.

> > > +	select ATA
> > > +	select SATA_AHCI_PLATFORM
> > > +	help
> > > +	  This option enables support for the IBM Akebono (476gtr) evaluation
> > > board +
> > > +
> > > 
> > >  config ICON
> > >  
> > >  	bool "Icon"
> > >  	depends on 44x
> > 
> > Paul Bolle
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


