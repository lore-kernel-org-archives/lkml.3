Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaIJIDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:03:18 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41076 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaIJIDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:03:14 -0400
Message-ID: <541005D5.7020902@arm.com>
Date: Wed, 10 Sep 2014 09:03:33 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Henrik Austad <henrik@austad.us>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "luca.abeni@unitn.it" <luca.abeni@unitn.it>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "raistlin@linux.it" <raistlin@linux.it>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/5] SCHED_DEADLINE documentation fixes and improvements
References: <1410256636-26171-1-git-send-email-juri.lelli@arm.com> <20140909211739.GA20822@sisyphus.home.austad.us>
In-Reply-To: <20140909211739.GA20822@sisyphus.home.austad.us>
X-OriginalArrivalTime: 10 Sep 2014 08:03:09.0322 (UTC) FILETIME=[A9073EA0:01CFCCCD]
X-MC-Unique: 114091009031112301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On 09/09/14 22:17, Henrik Austad wrote:
> On Tue, Sep 09, 2014 at 10:57:11AM +0100, Juri Lelli wrote:
>> Hello everyone,
> 
> Hi Juri,
> 
> Looks good! Didn't spot anything and pleased to see that minimal main() 
> made it into the appendix! :D
> 

Great! Thanks a lot.

Best,

- Juri

>> This is version 4 of a small patchset that fixes and improves SCHED_DEADLINE
>> documentation.
>>
>> Patch 1/5 fixes and clarifies terminology; patch 2/5 aligns Section 4 to
>> the current interface; patch 3/5 improves and clarifies what admission
>> control means on UP an SMP systems; patch 4/5 introduces an appendix about
>> testing; patch 5/5 introduces an appendix with a minimal main() for
>> application developers.
>>
>> Changes since v1:
>>
>>  - fixed typos spotted by Randy and Peter (thanks!)
>>
>> Changes since v2:
>>
>>  - fixed typos and rewrote paragraphs as suggested by Ingo (thanks!)
>>
>> Changes since v3:
>>
>>  - addressed comments made by Henrik (thanks!)
>>  - added patch 5/5 (as Henrik asked)
> 
> To the whole series,
> 
> Reviewed-by: Henrik Austad <henrik@austad.us>
> 
>> Best Regards,
>>
>> - Juri
>>
>> Juri Lelli (3):
>>   Documentation/scheduler/sched-deadline.txt: Rewrite section 4 intro
>>   Documentation/scheduler/sched-deadline.txt: add tests suite appendix
>>   Documentation/scheduler/sched-deadline.txt: add minimal main()
>>     appendix
>>
>> Luca Abeni (2):
>>   Documentation/scheduler/sched-deadline.txt: fix terminology and
>>     improve clarity
>>   Documentation/scheduler/sched-deadline.txt: improve and clarify AC
>>     bits
>>
>>  Documentation/scheduler/sched-deadline.txt | 340 +++++++++++++++++++++++++----
>>  1 file changed, 292 insertions(+), 48 deletions(-)
>>
>> -- 
>> 2.0.4
>>
>>
> 

