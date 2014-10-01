Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaJAHyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:54:35 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37842 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaJAHy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:54:29 -0400
Message-ID: <542BB331.6020308@suse.cz>
Date: Wed, 01 Oct 2014 09:54:25 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
CC: stable@vger.kernel.org, shuah.kh@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/142] 3.12.29-stable review
References: <cover.1411724723.git.jslaby@suse.cz>	<20140926154536.GA7174@roeck-us.net> <87lhp4enlp.wl%satoru.takeuchi@gmail.com>
In-Reply-To: <87lhp4enlp.wl%satoru.takeuchi@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2014, 11:54 PM, Satoru Takeuchi wrote:
> At Fri, 26 Sep 2014 08:45:36 -0700,
> Guenter Roeck wrote:
>>
>> On Fri, Sep 26, 2014 at 11:45:33AM +0200, Jiri Slaby wrote:
>>> This is the start of the stable review cycle for the 3.12.29 release.
>>> There are 142 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Tue Sep 30 11:45:24 CEST 2014.
>>> Anything received after that time might be too late.
>>>
>>
>> Hi Jiri,
>>
>> Build results:
>> 	total: 135 pass: 135 fail: 0
>>
>> Qemu test results:
>> 	total: 21 pass: 21 fail: 0
>
> Plus, this kernel passed my test.

On 09/29/2014, 06:52 PM, Shuah Khan wrote:
> Compiled and booted on my test system. No dmesg regressions.

Hi, and thanks to all of you.

>> Both obviously look good, however my tree doesn't match your review
request.
>> It includes 245 patches instead of just 142.

It is because I went wild and already uploaded 3.12.30-rc1 (aka
performance release).

>> Looks like your tree is a bit ahead of time, so I guess that is ok.
>> Is there a way for me to avoid this when pulling in your pending
changes ?
>> So far I pull the changes from the stable-3.12-queue branch in your
>> repository at kernel.org.

Yeah, it is fine. You will receive a 30-rc1 message in a minute. (And if
you tested the stable-queue already, no need to retest :).)

thanks,
-- 
js
suse labs
