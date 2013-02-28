Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab3B1XuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:50:20 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:56301 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3B1XuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:50:18 -0500
Date: Wed, 27 Feb 2013 21:19:50 -0500
From: Andrew Shewmaker <agshew@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/2] mm: tuning hardcoded reserved memory
Message-ID: <20130228021950.GA3829@localhost.localdomain>
References: <20130227210925.GB8429@localhost.localdomain>
 <20130228141441.7dbd19be.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130228141441.7dbd19be.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 02:14:41PM -0800, Andrew Morton wrote:
> On Wed, 27 Feb 2013 16:09:25 -0500
> Andrew Shewmaker <agshew@gmail.com> wrote:
> 
> > Add a rootuser_reserve_pages knob to allow admins of large memory 
> > systems running with overcommit disabled to change the hardcoded 
> > memory reserve to something other than 3%.
> > 
> > Signed-off-by: Andrew Shewmaker <agshew@gmail.com>
> > 
> > ---
> > 
> > Patch based off of mmotm git tree as of February 27th.
> > 
> > I set rootuser_reserve pages to be a default of 1000, and I suppose 
> > I should have initialzed similarly to the way min_free_kbytes is, 
> > scaling it with the size of the box. However, I wanted to get a 
> > simple version of this patch out for feedback to see if it has any 
> > chance of acceptance or if I need to take an entirely different 
> > approach.
> > 
> > Any feedback will be appreciated!
> 
> Seems reasonable.
> 
> Yes, we should scale the initial value according to the machine size in
> some fashion.
> 
> btw, both these patches had the same title.  Please avoid this.
> Documentation/SubmittingPatches section 15 has all the details.

Sorry about that. I'll resend correctly formatted patche submissions 
with a scaled initial value for rootuser_reserve_pages.

Thanks for the feedback!
