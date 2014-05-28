Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbaE1Vy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:54:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57145 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaE1VyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:54:25 -0400
Message-ID: <53865B0F.6080706@infradead.org>
Date: Wed, 28 May 2014 14:54:23 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: werner <w.landgraf@ru.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.15-rc6  build / link failed  fs/built-in  mb_cache_entry problems
References: <redirect-87012843@zbackend1.aha.ru> <53841CED.9010800@infradead.org> <5385101D.4050504@hp.com> <538516EE.40209@infradead.org> <web-87633644@zbackend1.aha.ru>
In-Reply-To: <web-87633644@zbackend1.aha.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 01:48 PM, werner wrote:
> Oi think im using 4.2.4 . but the kernel should be programmed clean, so that it builds with all not-too-old versions.
> 
> wl
> 

Hi Werner,
Please reply to the mailing list also (as I am doing).

I asked Thavatchai for a patch to fix this.

> 
> 
> n Tue, 27 May 2014 15:51:26 -0700
>  Randy Dunlap <rdunlap@infradead.org> wrote:
>> On 05/27/2014 03:22 PM, Thavatchai Makphaibulchoke wrote:
>>> On 05/26/2014 11:04 PM, Randy Dunlap wrote:
>>>> On 05/26/2014 11:17 AM, werner wrote:
>>>> @tmac:  can mbcache.c #include <linux/log2.h> and use ilog2(NR_BG_LOCKS)
>>>> instead of using __builtin_log2(NR_BG_LOCKS) ?
>>>> (ref. commit ID 1f3e55fe02d12213f87869768aa2b0bad3ba9a7d)
>>>>
>>>
>>> I don't see any problem with that, unless somebody else has any concern.  Please let me know if you'd like me to submit the change.
>>
>> I'd say yes since some gcc version(s) don't seem to support __builtin_log2().
>>
>> -- 
>> ~Randy
>>
>>
> 
> "werner" <w.landgraf@ru.ru>
> ---
> Professional hosting for everyone - http://www.host.ru


-- 
~Randy
