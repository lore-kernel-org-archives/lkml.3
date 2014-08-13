Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaHMJDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:03:19 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41296 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaHMJDR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:03:17 -0400
Message-ID: <53EB29D8.80201@arm.com>
Date: Wed, 13 Aug 2014 10:03:20 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>,
        "peterz@infradead.org" <peterz@infradead.org>
CC: "luca.abeni@unitn.it" <luca.abeni@unitn.it>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "henrik@austad.us" <henrik@austad.us>,
        "raistlin@linux.it" <raistlin@linux.it>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Documentation/scheduler/sched-deadline.txt: fix terminology
 and improve clarity
References: <1407858555-14371-1-git-send-email-juri.lelli@arm.com> <1407858555-14371-2-git-send-email-juri.lelli@arm.com> <53EA52AC.1040504@infradead.org>
In-Reply-To: <53EA52AC.1040504@infradead.org>
X-OriginalArrivalTime: 13 Aug 2014 09:03:13.0112 (UTC) FILETIME=[697CF580:01CFB6D5]
X-MC-Unique: 114081310031504601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On 12/08/14 18:45, Randy Dunlap wrote:
> On 08/12/14 08:49, Juri Lelli wrote:
>> From: Luca Abeni <luca.abeni@unitn.it>
>>
>> ---
>>  Documentation/scheduler/sched-deadline.txt |   32 +++++++++++++++-------------
>>  1 file changed, 17 insertions(+), 15 deletions(-)
>>
>> diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
>> index 18adc92..db25eb5 100644
>> --- a/Documentation/scheduler/sched-deadline.txt
>> +++ b/Documentation/scheduler/sched-deadline.txt
>> @@ -147,6 +147,8 @@ CONTENTS
>>   and the absolute deadlines (d_j) coincide, so a proper admission control
>>   allows to respect the jobs' absolute deadlines for this task (this is what is
>>   called "hard schedulability property" and is an extension of Lemma 1 of [2]).
>> + Notice that if runtime > deadine the admission control will surely reject
> 
>                              deadline
> 

Good catch! Fixed.

Thanks,

- Juri

>> + this task, as it is not possible to respect its temporal constraints.
>>  
>>   References:
>>    1 - C. L. Liu and J. W. Layland. Scheduling algorithms for multiprogram-
> 
> 

