Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbaHLRpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:45:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:40447 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbaHLRpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:45:22 -0400
Message-ID: <53EA52AC.1040504@infradead.org>
Date: Tue, 12 Aug 2014 10:45:16 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>, peterz@infradead.org
CC: luca.abeni@unitn.it, mingo@redhat.com, henrik@austad.us, raistlin@linux.it,
        juri.lelli@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Documentation/scheduler/sched-deadline.txt: fix terminology
 and improve clarity
References: <1407858555-14371-1-git-send-email-juri.lelli@arm.com> <1407858555-14371-2-git-send-email-juri.lelli@arm.com>
In-Reply-To: <1407858555-14371-2-git-send-email-juri.lelli@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/14 08:49, Juri Lelli wrote:
> From: Luca Abeni <luca.abeni@unitn.it>
> 
> ---
>  Documentation/scheduler/sched-deadline.txt |   32 +++++++++++++++-------------
>  1 file changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
> index 18adc92..db25eb5 100644
> --- a/Documentation/scheduler/sched-deadline.txt
> +++ b/Documentation/scheduler/sched-deadline.txt
> @@ -147,6 +147,8 @@ CONTENTS
>   and the absolute deadlines (d_j) coincide, so a proper admission control
>   allows to respect the jobs' absolute deadlines for this task (this is what is
>   called "hard schedulability property" and is an extension of Lemma 1 of [2]).
> + Notice that if runtime > deadine the admission control will surely reject

                             deadline

> + this task, as it is not possible to respect its temporal constraints.
>  
>   References:
>    1 - C. L. Liu and J. W. Layland. Scheduling algorithms for multiprogram-


-- 
~Randy
