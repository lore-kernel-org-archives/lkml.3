Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbaCPD0m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 23:26:42 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:56671 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbaCPD0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 23:26:40 -0400
Message-ID: <53251A08.2040903@gmail.com>
Date: Sun, 16 Mar 2014 11:27:04 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] Makefile: about allmodconfig issue.
References: <531B1603.6080106@gmail.com> <531B3178.8000804@infradead.org> <531B8F2C.8080302@gmail.com> <531B9281.1080500@infradead.org> <531C8269.4010105@gmail.com> <531C95BE.1070306@infradead.org> <531E622A.5010200@gmail.com> <5324C687.9070104@gmail.com> <5324C7EA.2000909@infradead.org>
In-Reply-To: <5324C7EA.2000909@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2014 05:36 AM, Randy Dunlap wrote:
> On 03/15/2014 02:30 PM, Chen Gang wrote:
>> On 03/11/2014 09:08 AM, Chen Gang wrote:
>>> On 03/10/2014 12:24 AM, Randy Dunlap wrote:
>>>> On 03/09/2014 08:02 AM, Chen Gang wrote:
>> [...]
>>>>> Else ('depends on' priority is higher than 'select')
>>>>>
>>>>>  - some architectures can choose whether support IRQ_DOMAIN.
>>>>>
>>>>>  - if IRQ_DOMAIN enabled, our gpio driver can be used, and then select
>>>>>    GENERIC_IRQ_CHIP (need not consider about it selects IRQ_DOMAIN).
>>>>>
>>>>>  - else (IRQ_DOMAIN_disabled), we can not use our gpio driver, and also
>>>>>    can not select GENERIC_IRQ_CHIP (need not consider about it selects
>>>>>    IRQ_DOMAIN, either).
>>>>>
>>>>> Excuse me, I am not quite familiar with Kconfig grammar, can any members
>>>>> give a confirmation for it (whether 'select' priority is higher or equal
>>>>> than 'depends on').
>>>>
>>>> Sorry, I don't really understand the problem that you are trying to solve.
>>>> Maybe you could back up and explain the underlying problem... ?
>>>>
>>>
>>> If the fix patch applied (don't depend on IRQ_DOMAIN), I guess, if one
>>> architecture don't support IRQ_DOMAIN, GPIO_DWAPB may still be enabled
>>> and then let IRQ_DOMAIN enable too.
>>>
>>
>> Is it possible to still go further? For me, I still think, this is not
>> gpio driver's issue, the kbuild need be improved to support this using case.
>>
>> So, if it is necessary, I will/should try to go further about it.
> 
> 
> If you can demonstrate a problem, then please submit a patch for it,
> but don't just hypothesize a problem, actually show that there is one.
>

We are discussing this gpio driver's issue, and also discussing one fix
patch (remove IRQ_DOMAIN dependency).

For me, when discussing one patch (e.g. this fix patch), it is necessary
for patch maker to provide proofs to clear all related doubts from any
members (e.g. me).

And theoretically, 'kbuild' need support (implement correctly) the
priority between 'select' and 'depends on', or it can not express all
related features (although it can not cause real world issue, now).


Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
