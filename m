Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbaHFAvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 20:51:17 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54592 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbaHFAvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 20:51:14 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E17BFF.70403@roeck-us.net>
Date: Tue, 05 Aug 2014 17:51:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [GIT PULL] hwmon updates for 3.17
References: <20140805022209.GA13813@roeck-us.net>	<20140805131447.5cec84e5@canb.auug.org.au>	<53E04DF3.40604@roeck-us.net> <CA+55aFx26rhMq_y0wuBrGi+QhFH0Odtg2eof-r_J6L46opsrjA@mail.gmail.com>
In-Reply-To: <CA+55aFx26rhMq_y0wuBrGi+QhFH0Odtg2eof-r_J6L46opsrjA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 03:58 PM, Linus Torvalds wrote:
> On Mon, Aug 4, 2014 at 8:22 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>
>>> This branch was rewritten (but not rebased) to add 5 commits at its
>>> start and 8 commits at its end since yesterday's linux-next.
>>
>> Yes, the start because I missed to send a bunch of fixes to Linus last week
>> because I was on vacation
>> and merged it all together, and the end because I missed to push out a bunch
>> of patches for the same
>> reason. Everything did pass my test suite, though.
>>
>> If that is a problem, let me know.
>
> Please, next time, just send me *two* pull requests - one with the
> missed fixes, and one with the linux-next work. No point in rewriting
> the series so that all the commits are now different from the ones in
> linux-next.
>
Ok, will do.

> I've pulled it, but why rewrite history and mess up the next statistics?
>

Thanks,
Guenter

