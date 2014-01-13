Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaAMWqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 17:46:35 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39130 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaAMWqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 17:46:32 -0500
Date: Mon, 13 Jan 2014 14:46:31 -0800 (PST)
Message-Id: <20140113.144631.230680335708739346.davem@davemloft.net>
To: shahed.shaikh@qlogic.com
Cc: martin@kaiser.cx, himanshu.madhani@qlogic.com, rajesh.borundia@qlogic.com,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH -next] qlcnic: fix compiler warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <262CB373A6D1F14F9B81E82F74F77D5A46F52B8E@avmb2.qlogic.org>
References: <20140109155908.GA4351@reykholt.kaiser.cx>
	<262CB373A6D1F14F9B81E82F74F77D5A46F52B8E@avmb2.qlogic.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0DMkeG0027190

From: Shahed Shaikh <shahed.shaikh@qlogic.com>
Date: Fri, 10 Jan 2014 07:19:19 +0000

> 
> Adding netdev.
> 
>> -----Original Message-----
>> From: Martin Kaiser,,, [mailto:martin@reykholt.kaiser.cx] On Behalf Of
>> Martin Kaiser
>> Sent: Thursday, January 09, 2014 9:29 PM
>> To: Himanshu Madhani; Rajesh Borundia
>> Cc: linux-kernel; trivial@kernel.org
>> Subject: [PATCH -next] qlcnic: fix compiler warning
>> 
>> Add an explicit cast to fix the following warning (seen on Debian Wheezy, gcc
>> 4.7.2)
>> 
>> CC [M]  drivers/net/wireless/rtlwifi/rtl8192ce/trx.o
>>     drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c: In function
>> ¡qlcnic_send_filter¢:
>>     drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c:349:3: warning:
>>     passing argument 2 of ¡ether_addr_equal¢ from incompatible pointer type
>> [enabled by default]
>>     In file included from include/linux/if_vlan.h:16:0,
>>     from drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c:9:
>>     include/linux/etherdevice.h:244:20: note: expected ¡const u8 *¢ but
>> argument is of type ¡u64 *¢
>>
> 
> If I am not wrong, this patch should go to David's net-next tree.
>  
>> Signed-off-by: Martin Kaiser <martin@kaiser.cx>
> 
> Acked-by: Shahed Shaikh <shahed.shaikh@qlogic.com>

Please post the original patch to netdev so that it properly gets
queued up in patchwork, thank you very much.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
