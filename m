Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab3HGGoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:44:39 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:26892 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab3HGGoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:44:38 -0400
Message-ID: <5201EC6C.9090709@huawei.com>
Date: Wed, 7 Aug 2013 14:42:52 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Chen Gang <gang.chen@asianux.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, <xi.wang@gmail.com>,
        <nicolas.dichtel@6wind.com>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/sysctl_binary.c: improve the usage of return value
 'result'
References: <5200A5E6.9020803@asianux.com> <8761vibihw.fsf@xmission.com>  <5201D62B.6080905@asianux.com> <5201E192.7060108@huawei.com> <1375855849.2424.82.camel@joe-AO722>
In-Reply-To: <1375855849.2424.82.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/7 14:10, Joe Perches wrote:
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

I know, and that's why I didn't quote that part.

