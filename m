Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526AbaLKB0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:26:55 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:8650 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933151AbaLKB0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:26:54 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44840069"
Message-ID: <5488EF2C.6010502@cn.fujitsu.com>
Date: Thu, 11 Dec 2014 09:11:08 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: introduce helper macro for_each_cmsghdr
References: <5487DBD9.1010908@cn.fujitsu.com>  <1418194583.1047.8.camel@perches.com> <54880124.8040509@cn.fujitsu.com> <1418223106.18092.1.camel@perches.com>
In-Reply-To: <1418223106.18092.1.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,
On 12/10/2014 10:51 PM, Joe Perches wrote:

> On Wed, 2014-12-10 at 16:15 +0800, Gu Zheng wrote:
>> On 12/10/2014 02:56 PM, Joe Perches wrote:
>>> On Wed, 2014-12-10 at 13:36 +0800, Gu Zheng wrote:
>>>> Introduce helper macro for_each_cmsghdr as a wrapper of the enumerating
>>>> cmsghdr from msghdr, just cleanup. 
>>>
>>> This looks nicer.
>>> Ideally this would have used: [PATCH V3] as the subject
>>
>> The previous v2 thread was marked as mistake, so this is the really active
>> v2 version.
> 
> A buggy submitted version is still a version.
> Using an incremented version number helps.

Got it, this can also avoid some unnecessary misreading.
Thanks for your suggestion.

Regards,
Gu

> 
> 


