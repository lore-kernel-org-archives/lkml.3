Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab3HGF6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 01:58:19 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:15899 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab3HGF6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 01:58:18 -0400
Message-ID: <5201E192.7060108@huawei.com>
Date: Wed, 7 Aug 2013 13:56:34 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, <xi.wang@gmail.com>,
        <nicolas.dichtel@6wind.com>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/sysctl_binary.c: improve the usage of return value
 'result'
References: <5200A5E6.9020803@asianux.com> <8761vibihw.fsf@xmission.com> <5201D62B.6080905@asianux.com>
In-Reply-To: <5201D62B.6080905@asianux.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The right answer to the code is to config it out and then you don't have
>> to worry about it one way or another.
>>
> 
> Pardon?
> 
> Excuse me, my English is not quite well, I don't quite understand your
> meaning, could you please repeat again in details or say more clearly ?
> 
> 
>> The sysctl binary path has never been properly maintained and I don't
>> intend to start.   But I will spend 5 minutes to say this patch seems to
>> make the code worse not better.
>>
> 
> I guess no one ever invited you to maintain this file (for just as you
> said, this file will be removed), so don't worry about it.
> 
> Hmm... do you mean you spend 5 minutes to get a conclusion ? if so,
> better not use word 'seems' which is not a suitable word appeared in
> the results, proofs or conclusions.
> 

To be honest...

You are too bad in english to do kernel development. You don't seem to
know how to communicate in english...

And people easily get frustrated or even pissed off when discussing with
you. That's why tglx descided to put your emails into /dev/null...

> At least, one conclusion is: this patch switches from old-style to
> new-style, not for optimization.
> 
> But for sysctl_getname() and "checkpatch.pl" of this patch, better to
> get more discussion.
> 
> Is it OK ?

