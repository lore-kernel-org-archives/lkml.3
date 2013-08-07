Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab3HGGKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:10:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40542 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757077Ab3HGGKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:10:51 -0400
Message-ID: <1375855849.2424.82.camel@joe-AO722>
Subject: Re: [PATCH] kernel/sysctl_binary.c: improve the usage of return
 value 'result'
From: Joe Perches <joe@perches.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Chen Gang <gang.chen@asianux.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, xi.wang@gmail.com,
        nicolas.dichtel@6wind.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 06 Aug 2013 23:10:49 -0700
In-Reply-To: <5201E192.7060108@huawei.com>
References: <5200A5E6.9020803@asianux.com> <8761vibihw.fsf@xmission.com>
	 <5201D62B.6080905@asianux.com> <5201E192.7060108@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 13:56 +0800, Li Zefan wrote:
> >> The right answer to the code is to config it out and then you don't have
> >> to worry about it one way or another.
[]
> > Hmm... do you mean you spend 5 minutes to get a conclusion ? if so,
> > better not use word 'seems' which is not a suitable word appeared in
> > the results, proofs or conclusions.
[]
> You are too bad in english to do kernel development. You don't seem to
> know how to communicate in english...

I don't think that's true.

For instance, pessimization is a pretty
obscure word.  Most native English speakers
could probably guess what it meant, but I
couldn't hold any low opinion of non-native
speaker that asked "what does that mean".

The code communicates just fine.

Chen Gang could be a bit more careful when
making significant changes to core kernel
facilities.

(said the guy that broke just printk)

I think the fluent English speakers can be
tolerant reasonably well when the code is
correct and compelling (and correct).

cheers, Joe

