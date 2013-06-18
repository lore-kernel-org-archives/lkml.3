Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624Ab3FRVgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:36:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab3FRVgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:36:07 -0400
Date: Tue, 18 Jun 2013 14:36:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org,
        Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: Re: [PATCH V2 0/2] FMC: resend sample drivers
Message-ID: <20130618213606.GA10816@kroah.com>
References: <cover.1371589927.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1371589927.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 11:27:02PM +0200, Alessandro Rubini wrote:
> As suggested by Greg-KH [1] I'm resending the two example submodules
> (one carrier driver and one mezzanine driver) with a proper licence
> text for BSD. Among the various wordings, I chose the shortest one, as
> used by a number of drivers/net/wireless/ files.  Thank you David for
> checking the distribution policies.
> 
> I rebased to next-20130617 and rebuilt, with no conflicts. In any
> of the patches of the original series.
> 
> [1] https://lkml.org/lkml/2013/6/17/772:
>     "Just redo those two patches and send them as 'v2'")
> 
> Alessandro Rubini (2):
>   FMC: add a software carrier driver
>   FMC: add a software mezzanine driver

Did I only not apply 2 patches?  I thought there should be some more
that I'm missing here.  Can you resend _everything_ that I need to apply
that I haven't already?

thanks,

greg k-h
