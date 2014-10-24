Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbaJXNVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:21:15 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55971 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505AbaJXNVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:21:14 -0400
Message-ID: <544A524A.3090305@arm.com>
Date: Fri, 24 Oct 2014 14:21:14 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>
CC: "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent@legout.info" <vincent@legout.info>
Subject: Re: [PATCH 0/4] Fix various bits of AC and PI for SCHED_DEADLINE
References: <1414142198-18552-1-git-send-email-juri.lelli@arm.com> <544A3949.30305@bmw-carit.de>
In-Reply-To: <544A3949.30305@bmw-carit.de>
X-OriginalArrivalTime: 24 Oct 2014 13:21:11.0701 (UTC) FILETIME=[61303450:01CFEF8D]
X-MC-Unique: 114102414211110001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 24/10/14 12:34, Daniel Wagner wrote:
> Hi everyone,
> 
> On 10/24/2014 11:16 AM, Juri Lelli wrote:
>> Hi all,
>>
>> this is basically a resend of 4 patches fixing problems around AC
>> and PI related to SCHED_DEADLINE. You can find the full story here:
>>
>>  - https://lkml.org/lkml/2014/9/19/134
>>  - https://lkml.org/lkml/2014/9/24/493
>>
>> First two patches fix AC. They are the same as the previous version,
>> plus aligning to commit f10e00f4bf36 ("sched/dl: Use dl_bw_of() under
>> rcu_read_lock_sched()"). Last two fix PI.
>>
>> Thanks a lot again to Daniel for spending time fixing and testing
>> the PI stuff! And to Peter and Vincent for reviews and comments.
> 
> Thanks for the patches!
> 
>> Best Regards,
>>
>> - Juri
>>
>> Juri Lelli (4):
>>   sched/deadline: fix bandwidth check/update when migrating tasks
>>     between exclusive cpusets
>>   sched/deadline: ensure that updates to exclusive cpusets don't break
>>     AC
>>   sched/deadline: don't replenish from a !SCHED_DEADLINE entity
>>   sched/deadline: fix races between rt_mutex_setprio and dl_task_timer
> 
> I have tested the whole patch set with my test program and everything
> seems to work fine. If you like you can add a
> 

Cool! Thanks a lot.

> Tested-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
> 

Peter, maybe you can add it while applying them?

Thanks,

- Juri

