Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab3HMNzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:55:19 -0400
Received: from hotel311.server4you.de ([85.25.146.15]:34257 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757445Ab3HMNzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:55:16 -0400
Message-ID: <520A3AC1.2030709@monom.org>
Date: Tue, 13 Aug 2013 15:55:13 +0200
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: brcsmac kernel panic
References: <5207BA00.3030709@monom.org> <5208BB2D.2000705@broadcom.com> <52094156.7010905@monom.org> <520A3784.2060108@broadcom.com>
In-Reply-To: <520A3784.2060108@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 03:41 PM, Arend van Spriel wrote:
> On 08/12/2013 10:11 PM, Daniel Wagner wrote:
>> On 08/12/2013 12:38 PM, Arend van Spriel wrote:
>>> On 08/11/2013 06:21 PM, Daniel Wagner wrote:
>>>> I just updated my laptop (MacBook Air 2012) from 3.11-rc3+ to 3.11-rc4+
>>>> and since then brcsmac crashes short after enabling it.
>>>> Unfortunately, I
>>>> did also change some config flags in the area of cpufreq (enabling
>>>> p-state driver) so the configuration is not exactly the same. Before I
>>>> try to figure out what I have changed, I am posting the picture of the
>>>> crash. Maybe it is something obvious.
>>>>
>>>> v3.11-rc4-197-gd92581f
>>>> http://www.monom.org/misc/brcmsmac/v3.11-rc4.config
>>>> http://www.monom.org/misc/brcmsmac/IMAG0064.jpg
>>>
>>> Thanks, Daniel
>>>
>>> I was looking at this issue two weeks ago and just got back from my
>>> vacation. Can you apply the patch and send me a kernel log?
>>
>> Sure, the patch does the trick, the panic is gone.
>
> Unfortunately, it results in a lot of error print and phy tx errors that
> has been reported by others. I think the two are related, but I have not
> root caused it yet. Your laptop may be usable now, but wireless
> performance is probably bad.
>
> Too bad I can not reproduce the issue over here. Are you willing to test
> some patches when I got a better grasp on the issue?

Sure, let there be patches. :)

cheers,
daniel

