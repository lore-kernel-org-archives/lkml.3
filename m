Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab3HWRS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:18:28 -0400
Received: from smtp2.Stanford.EDU ([171.67.219.82]:50627 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755595Ab3HWRS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:18:26 -0400
Message-ID: <52179950.6010601@localhost>
Date: Fri, 23 Aug 2013 10:18:08 -0700
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.9-rt5
References: <20130822182127.GA7606@linutronix.de> <5216F81A.4050203@localhost> <52170A6F.6040009@linutronix.de>
In-Reply-To: <52170A6F.6040009@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2013 12:08 AM, Sebastian Andrzej Siewior wrote:
> On 08/23/2013 07:50 AM, Fernando Lopez-Lezcano wrote:
>> On 08/22/2013 11:21 AM, Sebastian Andrzej Siewior wrote:
>>> - hwlat improvements by Steven
>>>
>>> Known issues:
>> ...
>> Trying to build I get (in make modules):
>>
>> ERROR: "__udivdi3" [drivers/misc/hwlat_detector.ko] undefined!
>> make[1]: *** [__modpost] Error 1
>> make: *** [modules] Error 2
>
> looks like someone forgot to do do_div() instead / which fails on 32bit
> if used on a 64bit dividend.
>
> Will fix later.

Please post a patch when/if you have it so I can retry the build...
Thanks for taking a look at this!
-- Fernando
