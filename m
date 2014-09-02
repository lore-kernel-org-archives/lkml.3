Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbaIBVzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:55:18 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:56370 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbaIBVzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:55:16 -0400
Date: Tue, 2 Sep 2014 23:55:10 +0200
From: Henrik Austad <henrik@austad.us>
To: Juri Lelli <juri.lelli@arm.com>
Cc: peterz@infradead.org, luca.abeni@unitn.it, rdunlap@infradead.org,
        mingo@redhat.com, raistlin@linux.it, juri.lelli@gmail.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] SCHED_DEADLINE documentation fixes and
 improvements
Message-ID: <20140902215510.GE22581@sisyphus.home.austad.us>
References: <1409220029-9002-1-git-send-email-juri.lelli@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409220029-9002-1-git-send-email-juri.lelli@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 11:00:25AM +0100, Juri Lelli wrote:
> Hello everyone,
> 
> This is version 3 of a small patchset that fixes and improves SCHED_DEADLINE
> documentation.
> 
> Patch 1/4 fixes and clarifies terminology; patch 2/4 aligns Section 4 to
> the current interface; patch 3/4 improves and clarifies what admission
> control means on UP an SMP systems; patch 4/4 introduces an appendix about
> testing.

For patch 1 & 2, please consider adding a Reviewed-by from me (there's 
some nitpick, but nothing serious).

For patch 3 & 4 I have some comments, but again, nothing severe. I'd like a 
short feedback before adding a reviewed-by though.

All in all, nice work! :D

> 
> Changes since v1:
> 
>  - fixed typos spotted by Randy and Peter (thanks!)
> 
> Changes since v2:
> 
>  - fixed typos and rewrote paragraphs as suggested by Ingo (thanks!)
> 
> Best Regards,
> 
> - Juri
> 
> Juri Lelli (2):
>   Documentation/scheduler/sched-deadline.txt: Rewrite section 4 intro
>   Documentation/scheduler/sched-deadline.txt: add tests suite appendix
> 
> Luca Abeni (2):
>   Documentation/scheduler/sched-deadline.txt: fix terminology and
>     improve clarity
>   Documentation/scheduler/sched-deadline.txt: improve and clarify AC
>     bits
> 
>  Documentation/scheduler/sched-deadline.txt | 204 ++++++++++++++++++++++-------
>  1 file changed, 159 insertions(+), 45 deletions(-)
> 
> -- 
> 2.0.4
> 

-- 
Henrik
