Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbaCOVgp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 17:36:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38190 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190AbaCOVgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 17:36:44 -0400
Message-ID: <5324C7EA.2000909@infradead.org>
Date: Sat, 15 Mar 2014 14:36:42 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] Makefile: about allmodconfig issue.
References: <531B1603.6080106@gmail.com> <531B3178.8000804@infradead.org> <531B8F2C.8080302@gmail.com> <531B9281.1080500@infradead.org> <531C8269.4010105@gmail.com> <531C95BE.1070306@infradead.org> <531E622A.5010200@gmail.com> <5324C687.9070104@gmail.com>
In-Reply-To: <5324C687.9070104@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2014 02:30 PM, Chen Gang wrote:
> On 03/11/2014 09:08 AM, Chen Gang wrote:
>> On 03/10/2014 12:24 AM, Randy Dunlap wrote:
>>> On 03/09/2014 08:02 AM, Chen Gang wrote:
> [...]
>>>> Else ('depends on' priority is higher than 'select')
>>>>
>>>>  - some architectures can choose whether support IRQ_DOMAIN.
>>>>
>>>>  - if IRQ_DOMAIN enabled, our gpio driver can be used, and then select
>>>>    GENERIC_IRQ_CHIP (need not consider about it selects IRQ_DOMAIN).
>>>>
>>>>  - else (IRQ_DOMAIN_disabled), we can not use our gpio driver, and also
>>>>    can not select GENERIC_IRQ_CHIP (need not consider about it selects
>>>>    IRQ_DOMAIN, either).
>>>>
>>>> Excuse me, I am not quite familiar with Kconfig grammar, can any members
>>>> give a confirmation for it (whether 'select' priority is higher or equal
>>>> than 'depends on').
>>>
>>> Sorry, I don't really understand the problem that you are trying to solve.
>>> Maybe you could back up and explain the underlying problem... ?
>>>
>>
>> If the fix patch applied (don't depend on IRQ_DOMAIN), I guess, if one
>> architecture don't support IRQ_DOMAIN, GPIO_DWAPB may still be enabled
>> and then let IRQ_DOMAIN enable too.
>>
> 
> Is it possible to still go further? For me, I still think, this is not
> gpio driver's issue, the kbuild need be improved to support this using case.
> 
> So, if it is necessary, I will/should try to go further about it.


If you can demonstrate a problem, then please submit a patch for it,
but don't just hypothesize a problem, actually show that there is one.


-- 
~Randy
