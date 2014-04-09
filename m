Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964951AbaDISmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:42:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57165 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934095AbaDISmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:42:08 -0400
Date: Wed, 09 Apr 2014 14:42:06 -0400 (EDT)
Message-Id: <20140409.144206.149826397772279425.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH net 3/3] Drivers: net: hyperv: Address UDP checksum
 issues
From: David Miller <davem@davemloft.net>
In-Reply-To: <b9662fd6593d462e83c5b88af75d5f2e@BY2PR03MB299.namprd03.prod.outlook.com>
References: <4ae24ae5c6ea45c399e7be03c69dc442@BY2PR03MB299.namprd03.prod.outlook.com>
	<20140409.143655.2112963679697366338.davem@davemloft.net>
	<b9662fd6593d462e83c5b88af75d5f2e@BY2PR03MB299.namprd03.prod.outlook.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KY Srinivasan <kys@microsoft.com>
Date: Wed, 9 Apr 2014 18:39:57 +0000

> 
> 
>> -----Original Message-----
>> From: David Miller [mailto:davem@davemloft.net]
>> Sent: Wednesday, April 9, 2014 11:37 AM
>> To: KY Srinivasan
>> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
>> jasowang@redhat.com
>> Subject: Re: [PATCH net 3/3] Drivers: net: hyperv: Address UDP checksum
>> issues
>> 
>> From: KY Srinivasan <kys@microsoft.com>
>> Date: Wed, 9 Apr 2014 18:08:47 +0000
>> 
>> > Thanks Dave. I will COW the SKB before changing the checksum value. I
>> > do have a question though.  I looked at a bunch of hardware drivers
>> > and they modify the header information, specially checksum field and I
>> > could not see where they had COWed the skb. I was grepping for skb_cow
>> > in these drivers.
>> 
>> Look for skb_cow_head(), for example, the tg3.c driver uses this.
>> 
> Thank you. I will update this patch. Do you want me to resend the whole set or just
> this patch.

You never need to ask me this.

Always, when there is an update to any part of a series, re-submit the entire
series.
