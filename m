Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaIESXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:23:40 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:45208 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaIESXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:23:39 -0400
MIME-Version: 1.0
In-Reply-To: <5409C210.9040204@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	<1391971686-9517-17-git-send-email-richard@nod.at>
	<CAF0htA5xWQwkMqdp0_zz05DLJvyCOJZf-v1Rso20de5VWFmPTA@mail.gmail.com>
	<1397553547.1985.25.camel@x220>
	<CAF0htA403PKyAgQjrMpYgawNZWKZm06UYrgV-7N_9tbas=SniA@mail.gmail.com>
	<1397673008.6361.0.camel@x220>
	<1403082609.1984.66.camel@x220>
	<CAF0htA691-9ccAr1FX-7xdBgx+OYjv7bG0VRMzETj_=0HW9pUQ@mail.gmail.com>
	<1409909543.5546.150.camel@x220>
	<5409C156.4040405@roeck-us.net>
	<5409C210.9040204@nod.at>
Date: Sat, 6 Sep 2014 02:23:38 +0800
Message-ID: <CAF0htA6s40fZJ5bsLP4N_-+-61BkM8qcHtqcANGjRFmv=wQYNw@mail.gmail.com>
Subject: Re: [PATCH 16/28] Remove GENERIC_HAS_IOMAP
From: Lennox Wu <lennox.wu@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Guenter Roeck <linux@roeck-us.net>, Paul Bolle <pebolle@tiscali.nl>,
        Chen Liqin <liqin.linux@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch was applied in our tree, but we have not issued a pull
request because other patches are still under discussion.
We might issue a pull request first.

Best,
Lennox

2014-09-05 22:00 GMT+08:00 Richard Weinberger <richard@nod.at>:
> Am 05.09.2014 15:57, schrieb Guenter Roeck:
>> On 09/05/2014 02:32 AM, Paul Bolle wrote:
>>> Guenter, Richard,
>>>
>>> On Thu, 2014-06-19 at 03:53 +0800, Lennox Wu wrote:
>>>> 2014-06-18 17:10 GMT+08:00 Paul Bolle <pebolle@tiscali.nl>:
>>>>>> On Wed, 2014-04-16 at 20:30 +0200, Paul Bolle wrote:
>>>>>> On Thu, 2014-04-17 at 01:29 +0800, Lennox Wu wrote:
>>>>>>> OK, we will merge it into our tree.
>>>>>
>>>>> The last few messages in this thread were sent shortly after v3.15-rc1.
>>>>> We're now at v3.16-rc1 and those three references to GENERIC_HAS_IOMAP
>>>>> are still there.
>>>>>
>>>>> Are there any issues with this patch?
>>>>>
>>>>>
>>>>> Paul Bolle
>>>>>
>>>> NO, there is no issue. We just want to push patches in a batched way.
>>>> The patch will show recently. Thank you.
>>>
>>> And at v3.17-rc3 this patch has still not shown up in mainline. Do you
>>> have suggestions for an alternative route to get this triviality finally
>>> merged?
>>>
>>
>> I merged it with the latest kernel, added Lennox' Ack, and sent it to
>> trivial@kernel.org. Let's see what happens.
>
> Thanks a lot Guenther!
