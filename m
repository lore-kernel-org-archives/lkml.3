Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532AbaLKCFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 21:05:50 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:11872 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932937AbaLKCFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 21:05:49 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44841932"
Message-ID: <5488F84A.8090303@cn.fujitsu.com>
Date: Thu, 11 Dec 2014 09:50:02 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joe@perches.com>
Subject: Re: [PATCH v2] net: introduce helper macro for_each_cmsghdr
References: <20141210.134804.1383875260695429574.davem@davemloft.net> <20141210.144430.1749715282635917425.davem@davemloft.net> <5488EDF7.7070001@cn.fujitsu.com> <20141210.204703.1525194278635097457.davem@davemloft.net>
In-Reply-To: <20141210.204703.1525194278635097457.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,
On 12/11/2014 09:47 AM, David Miller wrote:

> From: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Date: Thu, 11 Dec 2014 09:05:59 +0800
> 
>> IMO, the user-land programs need to be build with the matched
>> headers separately.
> 
> You absolutely cannot provide this new interface to userland and
> expect programs to be able to just use it, it's non-standard and does
> not exist in older headers.

Got it, sorry for my mistake, and thanks for your correction.

> 
> I do not want this new interface available to userland programs.
> They can just open-code the list traversal just like every program
> in history has had to do since BSD UNIX.

Agree. Let's leave the user-land ones as they are.
I'll send a new version (without changing user-land ones) soon.

Best regards,
Gu

> .
> 


