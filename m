Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaIIVRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 17:17:46 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:32938 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbaIIVRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 17:17:45 -0400
Date: Tue, 9 Sep 2014 23:17:39 +0200
From: Henrik Austad <henrik@austad.us>
To: Juri Lelli <juri.lelli@arm.com>
Cc: peterz@infradead.org, luca.abeni@unitn.it, rdunlap@infradead.org,
        mingo@redhat.com, raistlin@linux.it, juri.lelli@gmail.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] SCHED_DEADLINE documentation fixes and
 improvements
Message-ID: <20140909211739.GA20822@sisyphus.home.austad.us>
References: <1410256636-26171-1-git-send-email-juri.lelli@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410256636-26171-1-git-send-email-juri.lelli@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 10:57:11AM +0100, Juri Lelli wrote:
> Hello everyone,

Hi Juri,

Looks good! Didn't spot anything and pleased to see that minimal main() 
made it into the appendix! :D

> This is version 4 of a small patchset that fixes and improves SCHED_DEADLINE
> documentation.
> 
> Patch 1/5 fixes and clarifies terminology; patch 2/5 aligns Section 4 to
> the current interface; patch 3/5 improves and clarifies what admission
> control means on UP an SMP systems; patch 4/5 introduces an appendix about
> testing; patch 5/5 introduces an appendix with a minimal main() for
> application developers.
> 
> Changes since v1:
> 
>  - fixed typos spotted by Randy and Peter (thanks!)
> 
> Changes since v2:
> 
>  - fixed typos and rewrote paragraphs as suggested by Ingo (thanks!)
> 
> Changes since v3:
> 
>  - addressed comments made by Henrik (thanks!)
>  - added patch 5/5 (as Henrik asked)

To the whole series,

Reviewed-by: Henrik Austad <henrik@austad.us>

> Best Regards,
> 
> - Juri
> 
> Juri Lelli (3):
>   Documentation/scheduler/sched-deadline.txt: Rewrite section 4 intro
>   Documentation/scheduler/sched-deadline.txt: add tests suite appendix
>   Documentation/scheduler/sched-deadline.txt: add minimal main()
>     appendix
> 
> Luca Abeni (2):
>   Documentation/scheduler/sched-deadline.txt: fix terminology and
>     improve clarity
>   Documentation/scheduler/sched-deadline.txt: improve and clarify AC
>     bits
> 
>  Documentation/scheduler/sched-deadline.txt | 340 +++++++++++++++++++++++++----
>  1 file changed, 292 insertions(+), 48 deletions(-)
> 
> -- 
> 2.0.4
> 
> 

-- 
Henrik Austad
