Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaEYSdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 14:33:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaEYSdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 14:33:06 -0400
Date: Sun, 25 May 2014 11:33:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Manuel Schoelling <manuel.schoelling@gmx.de>
Cc: devel@driverdev.osuosl.org, arnd@arndb.de, peter.p.waskiewicz.jr@intel.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        khoroshilov@ispras.ru
Subject: Re: [PATCH] staging: gdm72xx: use time_before()
Message-ID: <20140525183305.GA11364@kroah.com>
References: <1401023339-29712-1-git-send-email-manuel.schoelling@gmx.de>
 <20140525181431.GA20614@kroah.com>
 <1401042273.7538.10.camel@schoellingm.dzne.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401042273.7538.10.camel@schoellingm.dzne.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2014 at 08:24:33PM +0200, Manuel Schoelling wrote:
> On So, 2014-05-25 at 11:14 -0700, Greg KH wrote:
> > On Sun, May 25, 2014 at 03:08:59PM +0200, Manuel Schölling wrote:
> > > To be future-proof and for better readability the time comparisons are
> > > modified to use time_before() instead of plain, error-prone math.
> > > 
> > > Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
> > > ---
> > >  drivers/staging/gdm72xx/gdm_usb.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > This patch doesn't apply, can you please refresh it against my latest
> > tree and resend?
> That's weird. I pulled the lastest master from Linus and rebased the
> patch, but no modification of my patch was required (latest commit
> before my patch to that file was
> 8943a92fc257c439ffe55fb0f9896be57c58c56b according to my repo). 
> 
> Maybe you have a more recent version than Linus?


I have a much different version from Linus, with a few thousand patches
added, otherwise how would I be able to queue up stuff to go to Linus
for the next kernel release?  :)

For the staging patches, either use the linux-next tree (which you
should use for all kernel development), or my staging.git tree, and the
staging-next branch on git.kernel.org, which is what gets pulled into
linux-next every week-day.

If you have more questions about this, take a look at
Documentation/development-process/  it should explain how patches move
to Linus and why working against Linus's tree isn't going to get you
very far.

thanks,

greg k-h
