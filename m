Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbaJXLey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:34:54 -0400
Received: from mail.bmw-carit.de ([62.245.222.98]:52365 "EHLO
	mail.bmw-carit.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbaJXLex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:34:53 -0400
Message-ID: <544A3949.30305@bmw-carit.de>
Date: Fri, 24 Oct 2014 13:34:33 +0200
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>
CC: <juri.lelli@gmail.com>, <mingo@redhat.com>, <vincent@legout.info>
Subject: Re: [PATCH 0/4] Fix various bits of AC and PI for SCHED_DEADLINE
References: <1414142198-18552-1-git-send-email-juri.lelli@arm.com>
In-Reply-To: <1414142198-18552-1-git-send-email-juri.lelli@arm.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On 10/24/2014 11:16 AM, Juri Lelli wrote:
> Hi all,
> 
> this is basically a resend of 4 patches fixing problems around AC
> and PI related to SCHED_DEADLINE. You can find the full story here:
> 
>  - https://lkml.org/lkml/2014/9/19/134
>  - https://lkml.org/lkml/2014/9/24/493
> 
> First two patches fix AC. They are the same as the previous version,
> plus aligning to commit f10e00f4bf36 ("sched/dl: Use dl_bw_of() under
> rcu_read_lock_sched()"). Last two fix PI.
> 
> Thanks a lot again to Daniel for spending time fixing and testing
> the PI stuff! And to Peter and Vincent for reviews and comments.

Thanks for the patches!

> Best Regards,
> 
> - Juri
> 
> Juri Lelli (4):
>   sched/deadline: fix bandwidth check/update when migrating tasks
>     between exclusive cpusets
>   sched/deadline: ensure that updates to exclusive cpusets don't break
>     AC
>   sched/deadline: don't replenish from a !SCHED_DEADLINE entity
>   sched/deadline: fix races between rt_mutex_setprio and dl_task_timer

I have tested the whole patch set with my test program and everything
seems to work fine. If you like you can add a

Tested-by: Daniel Wagner <daniel.wagner@bmw-carit.de>

cheers,
daniel
