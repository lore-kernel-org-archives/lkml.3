Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbaDKPXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 11:23:54 -0400
Received: from forward2m.mail.yandex.net ([37.140.138.2]:38957 "EHLO
	forward2m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757942AbaDKPXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 11:23:53 -0400
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2014 11:23:53 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: Sasha Levin <sasha.levin@oracle.com>,
        Michael wang <wangyun@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "ktkhai@parallels.com" <ktkhai@parallels.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <5347FCED.8040706@oracle.com>
References: <5304F32A.4040907@oracle.com> <5305856F.3000109@linux.vnet.ibm.com> <53078241.3060201@oracle.com> <53080122.609@linux.vnet.ibm.com> <530ABB44.5000601@oracle.com> <530AD653.3000808@linux.vnet.ibm.com> <20140224071028.GW9987@twins.programming.kicks-ass.net> <530B1B80.4000307@linux.vnet.ibm.com> <20140224121218.GR15586@twins.programming.kicks-ass.net> <534610A4.5000302@oracle.com> <53464164.5030701@linux.vnet.ibm.com> <336561397137116@web27h.yandex.ru> <5347FCED.8040706@oracle.com>
Subject: Re: sched: hang in migrate_swap
MIME-Version: 1.0
Message-Id: <1442521397229373@web20m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 11 Apr 2014 19:16:13 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11.04.2014, 18:33, "Sasha Levin" <sasha.levin@oracle.com>:
> On 04/10/2014 09:38 AM, Kirill Tkhai wrote:
>
>> š10.04.2014, 11:00, "Michael wang" <wangyun@linux.vnet.ibm.com>:
>>>> šOn 04/10/2014 11:31 AM, Sasha Levin wrote:
>>>> š[snip]
>>>>>> ššI'd like to re-open this issue. It seems that something broke and I'm
>>>>>> ššnow seeing the same issues that have gone away 2 months with this patch
>>>>>> ššagain.
>>>> šA new mechanism has been designed to move the priority checking inside
>>>> šidle_balance(), including Kirill who is the designer ;-)
>> šNot sure, it's connected with my patch. But looks like, we forgot
>> šexactly stop class. Maybe this will help?
>>
>> š[PATCH] sched: Checking for stop task appearance when balancing happens
>>
>> šJust do it, like we do for other higher priority classes...
>>
>> šSigned-off-by: Kirill Tkhai <tkhai@yandex.ru>
>
> I've been running with this patch for the last two days and the hang
> seems to be gone.
>
> I'll leave it running on the weekend and will update again on Monday.

Thanks for testing.

Sorry for I killed your linuxes by this lost need_resched().

>
> Thanks,
> Sasha
