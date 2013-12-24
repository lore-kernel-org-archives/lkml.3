Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab3LXPeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 10:34:21 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:38966 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3LXPeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 10:34:20 -0500
Message-ID: <52B9A6C0.6040303@gmail.com>
Date: Tue, 24 Dec 2013 23:22:40 +0800
From: Ding Tianhong <dthxman@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH v2 01/20] net: slight optimization of addr compare for
 some modules
References: <52B96F9B.4020806@huawei.com>	 <1387894944.2259.31.camel@joe-AO722> <52B99BB9.9030201@gmail.com> <1387897517.2259.41.camel@joe-AO722>
In-Reply-To: <1387897517.2259.41.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/12/24 23:05, Joe Perches 写道:
> On Tue, 2013-12-24 at 22:35 +0800, Ding Tianhong wrote:
>> 于 2013/12/24 22:22, Joe Perches 写道:
>>> On Tue, 2013-12-24 at 19:27 +0800, Ding Tianhong wrote:
>>>> Use possibly more efficient ether_addr_equal_unaligned
>>>> and ether_addr_equal to instead of memcmp.
>>>
>>> A negative of adding so many different drivers in a single
>>> patch is that you miss sending patches to the named maintainers.
>>>
>>> Most of these below have separate individual maintainers.
>>
>> you mean that I should send below by separate patch?
> 
> I think yes,
> 
> You can send them to netdev, but cc'ing the named
> maintainers is a polite thing to do.
> 
> Sending individual patches can make it easier for
> maintainers to review the bits that are specific
> to their projects without having to wade through
> other changes that aren't relevant to them.
> 

OK, I will rebuild the 01/20 patch and make it to seperate patches follow your opinion.
and the rest of the patches I think is fit and no need to modify, if you agree with me,
I will send the rest 19 patch as the first step, and then seperate this patch as the second
step, send them in net-next.

Regards
Ding

>> It seemed that I 
>> misunderstood, I use the ./script/getmainter and found the only maintainer
>> is David, and others are support, so maybe I was wrong, but it really a big
>> patchset, could I send them by seperate patchset? I think it could be more
>> clearly.
> 
>>From the MAINTAINERS file:
> 	S: Status, one of the following:
> 	   Supported:	Someone is actually paid to look after this.
> 	   Maintained:	Someone actually looks after it.
> 	   Odd Fixes:	It has a maintainer but they don't have time to do
> 			much other than throw the odd patch in. See below..
> 	   Orphan:	No current maintainer [but maybe you could take the
> 			role as you write your new code].
> 	   Obsolete:	Old code. Something tagged obsolete generally means
> 			it has been replaced by a better system and you
> 			should be using that.
> 
> So "supported" is "higher/better" than "maintained".
> 

OK

> 
> 

