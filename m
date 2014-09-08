Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbaIHRGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:06:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbaIHRGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:06:13 -0400
Date: Mon, 8 Sep 2014 10:06:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        *S-Par-Maintainer <SParMaintainer@unisys.com>,
        "Kershner, David A" <David.Kershner@unisys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: unisys: uislib: uislib.c: sparse warning of
 context imbalance
Message-ID: <20140908170613.GB10454@kroah.com>
References: <1409908966-23148-1-git-send-email-sudipm.mukherjee@gmail.com>
 <C97001BC43954D438ACB059713BA5CDFC97127E0E1@USEA-EXCH7.na.uis.unisys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C97001BC43954D438ACB059713BA5CDFC97127E0E1@USEA-EXCH7.na.uis.unisys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 10:57:08AM -0500, Romer, Benjamin M wrote:
> On Fri, 2014-09-05 at 14:52 +0530, Sudip Mukherjee wrote:
> > fixed sparse warning : context imbalance in 'pause_device' 
> > 			unexpected unlock
> > this patch will generate warning from checkpatch for 
> > lines over 80 character , but since those are user-visible strings
> > so it was not modified.
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> > 
> > hi , can you please review the patch and see if the approach is correct.
> > The functiion is still doing the same what it was doing , only the logic
> > is changed. if the approach is ok, then i can send a patch to fix the
> > other two similar warning in the file.
> 
> Hi Sudip,
> 
> I was able to successfully build and test your patch. The changes look
> good to me too, so I think we should take this patch. :)

Traditionally, you would respond with a:
	Acked-by: Developer Name <email@address>
so I can add it to the patch.

Care to do that here?

thanks,

greg k-h
