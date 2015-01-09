Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbbAIEDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 23:03:16 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50738 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbbAIEDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 23:03:14 -0500
Date: Thu, 08 Jan 2015 20:08:58 -0800 (PST)
Message-Id: <20150108.200858.548066819871890131.davem@davemloft.net>
To: David.Laight@ACULAB.COM
Cc: hau@realtek.com, netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 07/11] r8169:update rtl8168f pcie ephy
 parameter
From: David Miller <davem@davemloft.net>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CAC2C99@AcuExch.aculab.com>
References: <1420648826-12972-1-git-send-email-hau@realtek.com>
	<1420648826-12972-8-git-send-email-hau@realtek.com>
	<063D6719AE5E284EB5DD2968C1650D6D1CAC2C99@AcuExch.aculab.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Jan 2015 20:03:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 7 Jan 2015 16:45:58 +0000

> From: Chunhao Lin
>> @@ -5852,7 +5852,9 @@ static void rtl_hw_start_8168f_1(struct rtl8169_private *tp)
>>  		{ 0x06, 0x00c0,	0x0020 },
>>  		{ 0x08, 0x0001,	0x0002 },
>>  		{ 0x09, 0x0000,	0x0080 },
>> -		{ 0x19, 0x0000,	0x0224 }
>> +		{ 0x19, 0x0000,	0x0224 },
>> +		{ 0x00, 0x0000,	0x0008 },
>> +		{ 0x0c, 0x3df0,	0x0200 }
> 
> I can't help feeling these lines all require short comments.

Agreed.

And this goes for some of the other patches that look like this too.
