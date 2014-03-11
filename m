Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaCKO66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:58:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26067 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbaCKO65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:58:57 -0400
Message-ID: <531F24A6.2020409@oracle.com>
Date: Tue, 11 Mar 2014 10:58:46 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>, Dave Jones <davej@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Bob Liu <bob.liu@oracle.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: bad rss-counter message in 3.14rc5
References: <20140311024906.GA9191@redhat.com> <20140310201340.81994295.akpm@linux-foundation.org> <20140310214612.3b4de36a.akpm@linux-foundation.org> <20140311045109.GB12551@redhat.com> <20140310220158.7e8b7f2a.akpm@linux-foundation.org> <20140311053017.GB14329@redhat.com> <20140311132024.GC32390@moon> <531F0E39.9020100@oracle.com> <20140311134158.GD32390@moon> <20140311142817.GA26517@redhat.com> <20140311143750.GE32390@moon>
In-Reply-To: <20140311143750.GE32390@moon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 10:37 AM, Cyrill Gorcunov wrote:
> On Tue, Mar 11, 2014 at 10:28:17AM -0400, Dave Jones wrote:
>> On Tue, Mar 11, 2014 at 05:41:58PM +0400, Cyrill Gorcunov wrote:
>>   > On Tue, Mar 11, 2014 at 09:23:05AM -0400, Sasha Levin wrote:
>>   > > >>
>>   > > >>Ok, with move_pages excluded it still oopses.
>>   > > >
>>   > > >Dave, is it possible to somehow figure out was someone reading pagemap file
>>   > > >at moment of the bug triggering?
>>   > >
>>   > > We can sprinkle printk()s wherever might be useful, might not be 100% accurate but
>>   > > should be close enough to confirm/deny the theory.
>>   >
>>   > After reading some more, I suppose the idea I had is wrong, investigating.
>>   > Will ping if I find something.
>>
>> I can rule it out anyway, I can reproduce this by telling trinity to do nothing
>> other than mmap()'s.   I'll try and narrow down the exact parameters.
>
> Dave, iirc trinity can write log file pointing which exactly syscall sequence
> was passed, right? Share it too please.

I've sent one of those last time I reported this issue:

	https://lkml.org/lkml/2014/1/22/625


Thanks,
Sasha
