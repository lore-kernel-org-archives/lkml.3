Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaHMJFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:05:44 -0400
Received: from service87.mimecast.com ([91.220.42.44]:32775 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaHMJFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:05:43 -0400
Message-ID: <53EB2A6A.3040304@arm.com>
Date: Wed, 13 Aug 2014 10:05:46 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: luca abeni <luca.abeni@unitn.it>, Randy Dunlap <rdunlap@infradead.org>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "henrik@austad.us" <henrik@austad.us>,
        "raistlin@linux.it" <raistlin@linux.it>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] Documentation/scheduler/sched-deadline.txt: improve
 and clarify AC bits
References: <1407858555-14371-1-git-send-email-juri.lelli@arm.com>	<1407858555-14371-4-git-send-email-juri.lelli@arm.com>	<53EA58B4.8050307@infradead.org> <20140812232219.4a7b4255@utopia>
In-Reply-To: <20140812232219.4a7b4255@utopia>
X-OriginalArrivalTime: 13 Aug 2014 09:05:39.0830 (UTC) FILETIME=[C0F05960:01CFB6D5]
X-MC-Unique: 114081310054103001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/08/14 22:22, luca abeni wrote:
> On Tue, 12 Aug 2014 11:11:00 -0700
> Randy Dunlap <rdunlap@infradead.org> wrote:
> [...]
>>> + The utilisation of a real-time task is defined as the ratio
>>> between its
>>> + wcet and its period (or minimum inter-arrival time), and
>>> represents
>>
>>    "wcet" seems to be used here without any explanation of what it
>> means.
> Sorry, this should have been "WCET" (Worst Case Execution Time), which
> is defined few lines above. I'll fix the typo (together with the other
> issues that have been pointed out).
> 

Yes, defined above. Fixed.

Thanks,

- Juri

> 			Thanks,
> 				Luca
> 

