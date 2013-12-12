Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab3LLB4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:56:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3LLB4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:56:13 -0500
Date: Wed, 11 Dec 2013 17:57:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, devel@driverdev.osuosl.org,
        fabs@goesec.de, tony@atomide.com, linux-kernel@vger.kernel.org,
        Steven Luo <steven@steven676.net>, pavel@ucw.cz, pali.rohar@gmail.com,
        Joe Perches <joe@perches.com>, nico@ngolde.de
Subject: Re: [PATCH] Staging: TIDSPBRIDGE: Use vm_iomap_memory for mmap-ing
 instead of remap_pfn_range
Message-ID: <20131212015752.GA14254@kroah.com>
References: <1386014416-4556-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20131207234912.GA1245@steven676.net>
 <52A81830.3000305@gmail.com>
 <20131211083359.GU28413@mwanda>
 <52A836F0.9070500@gmail.com>
 <20131211102717.GV28413@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211102717.GV28413@mwanda>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 01:27:17PM +0300, Dan Carpenter wrote:
> On Wed, Dec 11, 2013 at 11:57:04AM +0200, Ivaylo Dimitrov wrote:
> > On 11.12.2013 10:33, Dan Carpenter wrote:
> > >On Wed, Dec 11, 2013 at 09:45:52AM +0200, Ivajlo Dimitrov wrote:
> > >>I can pick your changes and re-send the original patch with them
> > >>incorporated if there are no objections. Are you fine with that?
> > >>
> > >Do it on top of staging-next, don't redo the original.
> > >
> > >regards,
> > >dan carpenter
> > 
> > I don't see the original patch in the staging-next tree [0], how to
> > proceed? Isn't it better to resend the original patch with Steven's
> > changes included?
> > 
> > [0] http://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/log/drivers/staging/tidspbridge?h=staging-next
> > 
> 
> Oops.  It's in staging-linus not staging-next.  I don't know how Greg
> handles that tree.

The same way I do my others:
	*-next : for the "next" kernel merge window
	*-linus : for Linus's tree now before the -final release comes out.

The original patch here went to Linus, so it was in staging-linus and
it's already in Linus's tree.

thanks,

greg k-h
