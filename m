Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbaICGnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 02:43:14 -0400
Received: from mail3.unitn.it ([193.205.206.24]:59295 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbaICGnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 02:43:13 -0400
Message-ID: <5406B874.5040507@unitn.it>
Date: Wed, 03 Sep 2014 08:43:00 +0200
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Henrik Austad <henrik@austad.us>, Juri Lelli <juri.lelli@arm.com>
CC: peterz@infradead.org, rdunlap@infradead.org, mingo@redhat.com,
        raistlin@linux.it, juri.lelli@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] Documentation/scheduler/sched-deadline.txt: fix
 terminology and improve clarity
References: <1409220029-9002-1-git-send-email-juri.lelli@arm.com> <1409220029-9002-2-git-send-email-juri.lelli@arm.com> <20140902211019.GA22581@sisyphus.home.austad.us>
In-Reply-To: <20140902211019.GA22581@sisyphus.home.austad.us>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/02/2014 11:10 PM, Henrik Austad wrote:
> On Thu, Aug 28, 2014 at 11:00:26AM +0100, Juri Lelli wrote:
>> From: Luca Abeni <luca.abeni@unitn.it>
>>
>> Several small changes regarding SCHED_DEADLINE documentation that fix
>> terminology and improve clarity and readability:
>>
>>   - "current runtime" becomes "remaining runtime"
>>
>>   - readablity of an equation is improved by introducing more spacing
>>
>>   - clarify when admission control will certainly fail
>>
>>   - new URL for CBS technical report
>>
>>   - substitue "smallest" with "closest"
>
> I'm tempted to say "earliest" (being part of the algorithm's name and all
> ;)
Well, AFAIR "closest" was suggested during the initial review some months ago...
Anyway, if now there is agreement on "earliest" I can change to it; let me know.

[...]
>>    Summing up, the CBS[2,3] algorithms assigns scheduling deadlines to tasks so
>>    that each task runs for at most its runtime every period, avoiding any
>>    interference between different tasks (bandwidth isolation), while the EDF[1]
>> - algorithm selects the task with the smallest scheduling deadline as the one
>> + algorithm selects the task with the closest scheduling deadline as the one
>>    to be executed first.  Thanks to this feature, also tasks that do not
>
> s/first/next/
>
> Also, next sentence does not make much sense, I would drop the also;
>
> "Thanks to this feature, tasks that do not strictly comply with the ..."
I agree with these changes, but they are in text that is not changed by my
patch, right?
What should I do? Add these changes to the patch, or send an additional incremental
patch with these changes?



				Thanks,
					Luca
