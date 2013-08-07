Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab3HGGZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:25:11 -0400
Received: from intranet.asianux.com ([58.214.24.6]:63023 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab3HGGZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:25:09 -0400
X-Spam-Score: -100.8
Message-ID: <5201E805.2080008@asianux.com>
Date: Wed, 07 Aug 2013 14:24:05 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, xi.wang@gmail.com,
        nicolas.dichtel@6wind.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/sysctl_binary.c: improve the usage of return value
 'result'
References: <5200A5E6.9020803@asianux.com> <8761vibihw.fsf@xmission.com> <5201D62B.6080905@asianux.com> <5201E192.7060108@huawei.com>
In-Reply-To: <5201E192.7060108@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 01:56 PM, Li Zefan wrote:
>>> The right answer to the code is to config it out and then you don't have
>>> to worry about it one way or another.
>>>
>>
>> Pardon?
>>
>> Excuse me, my English is not quite well, I don't quite understand your
>> meaning, could you please repeat again in details or say more clearly ?
>>
>>
>>> The sysctl binary path has never been properly maintained and I don't
>>> intend to start.   But I will spend 5 minutes to say this patch seems to
>>> make the code worse not better.
>>>
>>
>> I guess no one ever invited you to maintain this file (for just as you
>> said, this file will be removed), so don't worry about it.
>>
>> Hmm... do you mean you spend 5 minutes to get a conclusion ? if so,
>> better not use word 'seems' which is not a suitable word appeared in
>> the results, proofs or conclusions.
>>
> 
> To be honest...
> 
> You are too bad in english to do kernel development. You don't seem to
> know how to communicate in english...
> 

So I should improve my English, and now I am just trying improving.

At least, it is not an excuse to leave upstream kernel development, is
it right ?  or do you have additional ideas or suggestions ?


> And people easily get frustrated or even pissed off when discussing with
> you. That's why tglx descided to put your emails into /dev/null...
> 

If any member won't discuss with me because of my bad English, and put
my e-mail into "/dev/null", I can understand, and say sorry to them.

So I really need thank the members who still want to discuss with me.

Do you still want to discuss with me ? if not, please put my e-mail
into "/dev/null", I really can understand, and say sorry to you.

Thanks.

>> At least, one conclusion is: this patch switches from old-style to
>> new-style, not for optimization.
>>
>> But for sysctl_getname() and "checkpatch.pl" of this patch, better to
>> get more discussion.
>>
>> Is it OK ?
> 
> 
> 


-- 
Chen Gang
