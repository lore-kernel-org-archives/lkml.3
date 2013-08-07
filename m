Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab3HGGaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:30:14 -0400
Received: from intranet.asianux.com ([58.214.24.6]:61143 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3HGGaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:30:13 -0400
X-Spam-Score: -100.8
Message-ID: <5201E937.4010107@asianux.com>
Date: Wed, 07 Aug 2013 14:29:11 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Li Zefan <lizefan@huawei.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, xi.wang@gmail.com,
        nicolas.dichtel@6wind.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/sysctl_binary.c: improve the usage of return value
 'result'
References: <5200A5E6.9020803@asianux.com> <8761vibihw.fsf@xmission.com>  <5201D62B.6080905@asianux.com> <5201E192.7060108@huawei.com> <1375855849.2424.82.camel@joe-AO722>
In-Reply-To: <1375855849.2424.82.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 02:10 PM, Joe Perches wrote:
> On Wed, 2013-08-07 at 13:56 +0800, Li Zefan wrote:
>>>> The right answer to the code is to config it out and then you don't have
>>>> to worry about it one way or another.
> []
>>> Hmm... do you mean you spend 5 minutes to get a conclusion ? if so,
>>> better not use word 'seems' which is not a suitable word appeared in
>>> the results, proofs or conclusions.
> []
>> You are too bad in english to do kernel development. You don't seem to
>> know how to communicate in english...
> 
> I don't think that's true.
> 
> For instance, pessimization is a pretty
> obscure word.  Most native English speakers
> could probably guess what it meant, but I
> couldn't hold any low opinion of non-native
> speaker that asked "what does that mean".
> 
> The code communicates just fine.
> 
> Chen Gang could be a bit more careful when
> making significant changes to core kernel
> facilities.
> 

OK, thanks, I really should be more careful for making patches.

> (said the guy that broke just printk)
> 
> I think the fluent English speakers can be
> tolerant reasonably well when the code is
> correct and compelling (and correct).
> 
> cheers, Joe
> 
> 
> 

Thank you very much for your understanding.


-- 
Chen Gang
