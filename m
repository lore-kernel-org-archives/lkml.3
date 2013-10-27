Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3J0QY0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 12:24:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab3J0QY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 12:24:26 -0400
Date: Sun, 27 Oct 2013 09:26:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Steven Newbury <steve@snewbury.org.uk>
Cc: linux-kernel@vger.kernel.org, Naren Sankar <nsankar@broadcom.com>,
        Jarod Wilson <jarod@wilsonet.com>, Scott Davilla <davilla@4pi.com>,
        Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [PATCH] staging: Merge Crystal HD driver with linuxtv.org
Message-ID: <20131027162613.GA23822@kroah.com>
References: <1382891243.2598.10.camel@artifact>
 <20131027155408.GA22705@kroah.com>
 <1382893938.2598.24.camel@artifact>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382893938.2598.24.camel@artifact>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 05:12:18PM +0000, Steven Newbury wrote:
> > And these patches do a lot of new work to the driver, I'd rather see it
> > get fixed up properly and moved out of staging first, before adding new
> > support to it, otherwise why is it in staging at all?
> 
> That last part it a good question, it's been sitting there for 3 years,
> I assume there are specific things that need improving to get it out of
> staging?  Would the changes in this patch, without the support for new
> hw support be sufficient to get that to happen?  I can't test it without
> that support though...

See the TODO file for a list of things that need to be resolved.

I've been remiss in deleting some of the staging drivers lately, and
this one was on my shortlist for removal, but if you have hardware for
it, and want to adopt it, I'll gladly take the patches for getting your
stuff to work if you are going to work toward getting it out of staging.

thanks,

greg k-h
