Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab3HGHE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:04:27 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:54549 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099Ab3HGHE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:04:26 -0400
Message-ID: <5201F10B.7040102@huawei.com>
Date: Wed, 7 Aug 2013 15:02:35 +0800
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
References: <5200A5E6.9020803@asianux.com> <8761vibihw.fsf@xmission.com> <5201D62B.6080905@asianux.com> <5201E192.7060108@huawei.com> <5201E805.2080008@asianux.com>
In-Reply-To: <5201E805.2080008@asianux.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> To be honest...
>>
>> You are too bad in english to do kernel development. You don't seem to
>> know how to communicate in english...
>>
> 
> So I should improve my English, and now I am just trying improving.
> 
> At least, it is not an excuse to leave upstream kernel development, is
> it right ?  or do you have additional ideas or suggestions ?
> 

Two sugguestions.

The first one is, if you get a reply from a maintainer (especially a top
maintainer), try harder to understand/learn from that reply, but don't
keep asking why and don't keep arguing without much thinking. I think
what's why sometimes people are annoyed in the discussion with you.

The second one is, better focus on a specific subsystem and try to do some
real work. It's not bad to start making patches like this one, but it won't
do you any good in the long term. Don't get addicted in increasing patch
contribution.

