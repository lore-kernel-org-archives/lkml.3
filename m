Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaCUSzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 14:55:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35075 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaCUSzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 14:55:04 -0400
Date: Fri, 21 Mar 2014 14:55:01 -0400 (EDT)
Message-Id: <20140321.145501.2003616654661701935.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v4] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140321.144957.550032279989990583.davem@davemloft.net>
References: <1395354521-12632-1-git-send-email-haiyangz@microsoft.com>
	<20140321.144957.550032279989990583.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Mar 2014 11:55:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2LItI9j002259

From: David Miller <davem@davemloft.net>
Date: Fri, 21 Mar 2014 14:49:57 -0400 (EDT)

> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Thu, 20 Mar 2014 15:28:41 -0700
> 
>> This feature allows multiple channels to be used by each virtual NIC.
>> It is available on Hyper-V host 2012 R2.
>> 
>> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
>> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> Applied, thanks.

Actually I had to revert, this doesn't even compile.

drivers/net/hyperv/netvsc.c: In function ¡netvsc_channel_cb¢:
drivers/net/hyperv/netvsc.c:891:2: error: implicit declaration of function ¡get_per_channel_state¢ [-Werror=implicit-function-declaration]
drivers/net/hyperv/netvsc.c:891:9: warning: assignment makes pointer from integer without a cast [enabled by default]
drivers/net/hyperv/netvsc.c: In function ¡netvsc_device_add¢:
drivers/net/hyperv/netvsc.c:998:2: error: implicit declaration of function ¡set_per_channel_state¢ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[3]: *** [drivers/net/hyperv/netvsc.o] Error 1
make[3]: *** Waiting for unfinished jobs....
drivers/net/hyperv/rndis_filter.c: In function ¡netvsc_sc_open¢:
drivers/net/hyperv/rndis_filter.c:988:2: error: implicit declaration of function ¡set_per_channel_state¢ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[3]: *** [drivers/net/hyperv/rndis_filter.o] Error 1
make[2]: *** [drivers/net/hyperv] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers/net] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
