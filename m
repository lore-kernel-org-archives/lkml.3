Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3GKUT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 16:19:59 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:44771 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756019Ab3GKUT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 16:19:57 -0400
From: Eli Cohen <eli@mellanox.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: linux-next: Tree for Jul 11 (mellanox/mlx5)
Thread-Topic: linux-next: Tree for Jul 11 (mellanox/mlx5)
Thread-Index: AQHOfmVT64WWepzOm0q9pBJAcyjeXplf6p8A
Date: Thu, 11 Jul 2013 20:19:13 +0000
Message-ID: <CFE9BFE80FFE4D4892AA5D31387E310FAD4C5BF7@MTLDAG01.mtl.com>
References: <20130711141745.04259271113c165310ec4768@canb.auug.org.au>
 <51DEFA92.3010701@infradead.org>
In-Reply-To: <51DEFA92.3010701@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6BKK7Zu026134

I have this fixed in my tree and we run the driver on i386. I will check on Sunday why it is not in the patches submitted.

-----Original Message-----
From: Randy Dunlap [mailto:rdunlap@infradead.org] 
Sent: Thursday, July 11, 2013 9:35 PM
To: Stephen Rothwell
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Eli Cohen; netdev@vger.kernel.org; linux-rdma@vger.kernel.org
Subject: Re: linux-next: Tree for Jul 11 (mellanox/mlx5)

On 07/10/13 21:17, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130710:
> 

on i386:

ERROR: "__udivdi3" [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!


objdump tells me that this is in the function average_read().


Full randconfig file is attached.


-- 
~Randy
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
