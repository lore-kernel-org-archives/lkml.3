Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaEORvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:51:45 -0400
Received: from smtp2.Stanford.EDU ([171.67.219.82]:56417 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753139AbaEORvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:51:44 -0400
Message-ID: <5374FE9D.9020900@localhost>
Date: Thu, 15 May 2014 10:51:25 -0700
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.14-rt1
References: <20140411185739.GA6644@linutronix.de> <535BFAF0.5090306@localhost> <20140502113703.GE9178@linutronix.de>
In-Reply-To: <20140502113703.GE9178@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 04:37 AM, Sebastian Andrzej Siewior wrote:
> * Fernando Lopez-Lezcano | 2014-04-26 11:29:04 [-0700]:
>
>> Saw this a moment ago (3.14.1 + rt1, Fedora 19 laptop - I think I
>> have seen something similar in 3.12.x-r):
>
> Yes, you did: https://lkml.org/lkml/2014/3/7/163
> You did not test I've sent. Care to do so?

I did patch my kernel and (I think) I did not see the problem again. I 
did get some very occassional hangs that seemed to be video related but 
I think I could not see what had caused them.

>> Apr 26 11:16:11 localhost kernel: [   96.323248] ------------[ cut
>> here ]------------
>> Apr 26 11:16:11 localhost kernel: [   96.323262] WARNING: CPU: 0 PID:
>> 2051 at lib/list_debug.c:59 __list_del_entry+0xa1/0xd0()
>> Apr 26 11:16:11 localhost kernel: [   96.323264] list_del corruption.
>> prev->next should be ffff8802101196a0, but was 0000000000000001
>> Apr 26 11:16:11 localhost kernel: [   96.323266] Modules linked in:
>
> and please send backtrace information properly formatted. This is
> terrible hard to read.

Sorry about that, I will attach files in the future.

I re-patched 3.14.3-rt5 with a slightly tweaked version of you patch. 
Will see what happens and report back.
-- Fernando
