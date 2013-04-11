Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934696Ab3DKRP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:15:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36620 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab3DKRP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:15:27 -0400
Date: Thu, 11 Apr 2013 13:15:25 -0400 (EDT)
Message-Id: <20130411.131525.534345322345457759.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: buytenh@wantstofly.org, andrew@lunn.ch, jason@lakedaemon.net,
        florian@openwrt.org, sergei.shtylyov@cogentembedded.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mv643xx_eth: use managed devm_kzalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <51665DDF.4060205@gmail.com>
References: <1365626527-27233-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20130410.233933.2109788843089649198.davem@davemloft.net>
	<51665DDF.4060205@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 11 Apr 2013 10:15:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Thu, 11 Apr 2013 08:53:19 +0200

> On 04/11/2013 05:39 AM, David Miller wrote:
>> From: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>> Date: Wed, 10 Apr 2013 22:42:07 +0200
>>
>>> This patch moves shared private data kzalloc to managed devm_kzalloc
>>> and
>>> cleans now unneccessary kfree and error handling.
>>>
>>> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>>
>> This doesn't apply cleanly to the net-next tree.
> 
> Yeah. I sent two single patches for mv643xx_eth, while they should
> have been sent together in one patch set. I'll prepare a cover letter
> and resend both in one patch set.

If you don't number the patches or mention the dependency, there is no way
for people to know.
