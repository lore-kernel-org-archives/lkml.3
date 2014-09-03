Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbaICIqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:46:18 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45450 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbaICIqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:46:15 -0400
Date: Wed, 3 Sep 2014 10:46:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Henrik Austad <henrik@austad.us>
Cc: Juri Lelli <juri.lelli@arm.com>, peterz@infradead.org, luca.abeni@unitn.it,
        rdunlap@infradead.org, mingo@redhat.com, raistlin@linux.it,
        juri.lelli@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] SCHED_DEADLINE documentation fixes and
 improvements
Message-ID: <20140903084609.GA8021@gmail.com>
References: <1409220029-9002-1-git-send-email-juri.lelli@arm.com>
 <20140902215510.GE22581@sisyphus.home.austad.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902215510.GE22581@sisyphus.home.austad.us>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Henrik Austad <henrik@austad.us> wrote:

> On Thu, Aug 28, 2014 at 11:00:25AM +0100, Juri Lelli wrote:
> > Hello everyone,
> > 
> > This is version 3 of a small patchset that fixes and improves SCHED_DEADLINE
> > documentation.
> > 
> > Patch 1/4 fixes and clarifies terminology; patch 2/4 aligns Section 4 to
> > the current interface; patch 3/4 improves and clarifies what admission
> > control means on UP an SMP systems; patch 4/4 introduces an appendix about
> > testing.
> 
> For patch 1 & 2, please consider adding a Reviewed-by from me 
> (there's some nitpick, but nothing serious).
> 
> For patch 3 & 4 I have some comments, but again, nothing 
> severe. I'd like a short feedback before adding a reviewed-by 
> though.

I had these queued up, but I'll wait for the next round of 
patches before applying them.

Thanks,

	Ingo
