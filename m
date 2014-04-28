Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169AbaD1V7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:59:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45454 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230AbaD1V7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:59:34 -0400
Message-ID: <535ECF3F.4010607@infradead.org>
Date: Mon, 28 Apr 2014 14:59:27 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Richard Weinberger <richard@nod.at>, Rik van Riel <riel@redhat.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, umgwanakikbuti@gmail.com
Subject: Re: mmotm 2014-04-24-13-07 uploaded
References: <535992DD.3060808@infradead.org> <20140425100459.7824f676@annuminas.surriel.com> <535AC91A.1070504@infradead.org> <535ACB0E.4070600@infradead.org> <20140427062650.GW4496@linux.vnet.ibm.com> <20140428135540.GA14661@linux.vnet.ibm.com> <535E8D14.7080405@infradead.org> <535E8E17.2050600@nod.at> <20140428200640.GG4430@linux.vnet.ibm.com> <535EBAE6.3080907@infradead.org> <20140428211535.GK4430@linux.vnet.ibm.com>
In-Reply-To: <20140428211535.GK4430@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/14 14:15, Paul E. McKenney wrote:
> On Mon, Apr 28, 2014 at 01:32:38PM -0700, Randy Dunlap wrote:
>> On 04/28/14 13:06, Paul E. McKenney wrote:
>>> On Mon, Apr 28, 2014 at 07:21:27PM +0200, Richard Weinberger wrote:
>>>> Am 28.04.2014 19:17, schrieb Randy Dunlap:
>>>>>
>>>>> uml defconfig on x86_64:
>>>>>
>>>>>   CC      arch/um/kernel/asm-offsets.s
>>>>> In file included from include/linux/sem.h:5:0,
>>>>>                  from include/linux/sched.h:35,
>>>>>                  from arch/x86/um/shared/sysdep/kernel-offsets.h:2,
>>>>>                  from arch/um/kernel/asm-offsets.c:1:
>>>>> include/linux/rcupdate.h:257:20: error: static declaration of 'rcu_sysrq_start' follows non-static declaration
>>>>> include/linux/rcupdate.h:250:6: note: previous declaration of 'rcu_sysrq_start' was here
>>>>> include/linux/rcupdate.h:260:20: error: static declaration of 'rcu_sysrq_end' follows non-static declaration
>>>>> include/linux/rcupdate.h:251:6: note: previous declaration of 'rcu_sysrq_end' was here
>>>>> make[2]: *** [arch/um/kernel/asm-offsets.s] Error 1
>>>>>
>>>>>
>>>>> Please test your patch(es).
>>>
>>> Against exactly what?  ;-)
>>
>> see $Subject
> 
> Testing my patches against MMOTM would be Stephen Rothwell's job.  ;-)

I guess that's a joke, based on your emoticon.
Otherwise it makes no sense.


-- 
~Randy
