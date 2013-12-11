Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab3LKK1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 05:27:47 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41488 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3LKK1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 05:27:43 -0500
Date: Wed, 11 Dec 2013 13:27:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: devel@driverdev.osuosl.org, fabs@goesec.de, tony@atomide.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Steven Luo <steven@steven676.net>, pavel@ucw.cz, pali.rohar@gmail.com,
        Joe Perches <joe@perches.com>, nico@ngolde.de
Subject: Re: [PATCH] Staging: TIDSPBRIDGE: Use vm_iomap_memory for mmap-ing
 instead of remap_pfn_range
Message-ID: <20131211102717.GV28413@mwanda>
References: <1386014416-4556-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20131207234912.GA1245@steven676.net>
 <52A81830.3000305@gmail.com>
 <20131211083359.GU28413@mwanda>
 <52A836F0.9070500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A836F0.9070500@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 11:57:04AM +0200, Ivaylo Dimitrov wrote:
> On 11.12.2013 10:33, Dan Carpenter wrote:
> >On Wed, Dec 11, 2013 at 09:45:52AM +0200, Ivajlo Dimitrov wrote:
> >>I can pick your changes and re-send the original patch with them
> >>incorporated if there are no objections. Are you fine with that?
> >>
> >Do it on top of staging-next, don't redo the original.
> >
> >regards,
> >dan carpenter
> 
> I don't see the original patch in the staging-next tree [0], how to
> proceed? Isn't it better to resend the original patch with Steven's
> changes included?
> 
> [0] http://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/log/drivers/staging/tidspbridge?h=staging-next
> 

Oops.  It's in staging-linus not staging-next.  I don't know how Greg
handles that tree.

regards,
dan carpenter

