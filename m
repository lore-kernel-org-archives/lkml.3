Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbaICIhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:37:08 -0400
Received: from mail3.unitn.it ([193.205.206.24]:63255 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397AbaICIhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:37:04 -0400
Message-ID: <5406D32D.9030306@unitn.it>
Date: Wed, 03 Sep 2014 10:37:01 +0200
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Henrik Austad <henrik@austad.us>
CC: Juri Lelli <juri.lelli@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        rdunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Dario Faggioli <raistlin@linux.it>, Juri Lelli <juri.lelli@gmail.com>,
        LKML doc <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] Documentation/scheduler/sched-deadline.txt: improve
 and clarify AC bits
References: <1409220029-9002-1-git-send-email-juri.lelli@arm.com>	<1409220029-9002-4-git-send-email-juri.lelli@arm.com>	<20140902214538.GC22581@sisyphus.home.austad.us>	<5406BA02.20806@unitn.it> <CAM6o_m3VXiJO3ED_Rb-_Kfaw7mFyw_s4W0quQ_hSbpxgA_foLA@mail.gmail.com>
In-Reply-To: <CAM6o_m3VXiJO3ED_Rb-_Kfaw7mFyw_s4W0quQ_hSbpxgA_foLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 09:48 AM, Henrik Austad wrote:
> On Wed, Sep 3, 2014 at 8:49 AM, Luca Abeni <luca.abeni@unitn.it> wrote:
>
>> Hi,
>>
>> On 09/02/2014 11:45 PM, Henrik Austad wrote:
>> [...]
>>
>>   + On multiprocessor systems with global EDF scheduling (non partitioned
>>>> + systems), a sufficient test for schedulability can not be based on the
>>>> + utilisations (it can be shown that task sets with utilisations slightly
>>>> + larger than 1 can miss deadlines regardless of the number of CPUs M).
>>>> + However, as previously stated, enforcing that the total utilisation is
>>>> smaller
>>>> + than M is enough to guarantee that non real-time tasks are not starved
>>>> and
>>>> + that the tardiness of real-time tasks has an upper bound.
>>>>
>>>
>>> I'd _really_ appreciate a link to a paper where all of this is presented
>>> and proved!
>>>
>> Well, my original plan was to add the bibliography in the next round of
>> patches...
>> Is this ok?
>>
>
> Sure, but I don't see why you cannot add this now
Well, there are multiple papers to be cited here: the one showing that
in a pathological case you can have missed deadlines on M CPUs with utilisation
slightly larger than 1 (Dhall's effect), one or more papers presenting a more
advanced admission control for global EDF, one or more papers showing the tardiness
bound, ...
So, I'd like to spend some time doing some research to properly cite the most
appropriate references.

> you (or Juri?) did update one of the papers in this series, right?
In patch 1, I updated the URL for a publically available technical report I wrote
in 1998 (the old URL was in a web site I cannot access anymore, so I changed the
URL to point to a web site I can control).

> As long as an article with all the headache ends up here, I'm happy :)
As said, if possible I'd like to do it in the next batch of patches, so that
these updates are not delayed... If this is not ok, I'll update the patch
adding some references, but this will take some time.



			Thanks,
				Luca
