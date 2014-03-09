Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaCIQYd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 12:24:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60266 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaCIQYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 12:24:31 -0400
Message-ID: <531C95BE.1070306@infradead.org>
Date: Sun, 09 Mar 2014 09:24:30 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] Makefile: about allmodconfig issue.
References: <531B1603.6080106@gmail.com> <531B3178.8000804@infradead.org> <531B8F2C.8080302@gmail.com> <531B9281.1080500@infradead.org> <531C8269.4010105@gmail.com>
In-Reply-To: <531C8269.4010105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2014 08:02 AM, Chen Gang wrote:
> On 03/09/2014 05:58 AM, Randy Dunlap wrote:
>> On 03/08/2014 01:44 PM, Chen Gang wrote:
>>> On 03/08/2014 11:04 PM, Randy Dunlap wrote:
>>>> On 03/08/2014 05:07 AM, Chen Gang wrote:
>>> [...]
>>>>> Welcome any suggestions, discussions and completions.
>>>>>
>>>>> Thanks.
>>>>>
>>>>
>>>> A patch has already been submitted and applied by the subsystem maintainer.
>>>>
>>>> http://marc.info/?l=linux-gpio&m=139413626320431&w=2
>>>>
>>>>
>>>
>>> OK, Thanks.  And excuse me, I can not connect to this web site in China.
>>>
>>> Could you please past the patch contents in the reply mail? (or just let
>>> me know whether it is "make allmodconfig" issue, or only gpio driver's
>>> issue)
>>>
>>>
>>> Thanks.
>>
>> It's a gpio driver Kconfig patch -- not an allmodconfig issue.
>>
> 
> Can we say that the 'select' priority is higher or equal than 'depends
> on'?  If we really can say so, we need change our gpio driver.

what driver is "our gpio driver"?

Documentation/kbuild/kconfig-language.txt does not talk about priorities
of depends or select.

> Else ('depends on' priority is higher than 'select')
> 
>  - some architectures can choose whether support IRQ_DOMAIN.
> 
>  - if IRQ_DOMAIN enabled, our gpio driver can be used, and then select
>    GENERIC_IRQ_CHIP (need not consider about it selects IRQ_DOMAIN).
> 
>  - else (IRQ_DOMAIN_disabled), we can not use our gpio driver, and also
>    can not select GENERIC_IRQ_CHIP (need not consider about it selects
>    IRQ_DOMAIN, either).
> 
> Excuse me, I am not quite familiar with Kconfig grammar, can any members
> give a confirmation for it (whether 'select' priority is higher or equal
> than 'depends on').

Sorry, I don't really understand the problem that you are trying to solve.
Maybe you could back up and explain the underlying problem... ?


-- 
~Randy
