Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaBJGdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 01:33:03 -0500
Received: from m12-17.163.com ([220.181.12.17]:44401 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbaBJGdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 01:33:01 -0500
Date: Mon, 10 Feb 2014 14:32:36 +0800
From: "=?utf-8?B?bGl1anVubGlhbmdfbGps?=" <liujunliang_ljl@163.com>
To: "=?utf-8?B?Sm9lIFBlcmNoZXM=?=" <joe@perches.com>
Cc: "=?utf-8?B?ZGF2ZW0=?=" <davem@davemloft.net>,
        "=?utf-8?B?aG9ybXM=?=" <horms@verge.net.au>,
        "=?utf-8?B?cm9taWV1?=" <romieu@fr.zoreil.com>,
        "=?utf-8?B?Z3JlZ2to?=" <gregkh@linuxfoundation.org>,
        "=?utf-8?B?bmV0ZGV2?=" <netdev@vger.kernel.org>,
        "=?utf-8?B?bGludXgtdXNi?=" <linux-usb@vger.kernel.org>,
        "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>,
        "=?utf-8?B?c3VuaGVjaGVuZw==?=" <sunhecheng@vip.126.com>
References: <1392010419-5217-1-git-send-email-liujunliang_ljl@163.com>,
 <1392011221.3178.18.camel@joe-AO722>
Subject: =?utf-8?B?UmU6IFJlOiBbUEFUQ0hdIFVTQjJORVQgOiBTUjk4MDAgOiBPbmUgY2hpcCBVU0IyLjAgVVNCMk5FVCBTUjk4MDBEZXZpY2UgRHJpdmVyIFN1cHBvcnQ=?=
Message-ID: <201402101432356252495@163.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
X-CM-TRANSID: EcCowEDZ30J6cvhS3aBJAg--.876S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKF43XF1UWr13KrWrJF4DCFg_yoWfurXEga
	15ZrZ7Wr18tFsrKFn8JFyFqrs3Cw1jq3WIgFyDur97Zry3JFn3Gr1xZr4Ygr1DX397ury7
	Jr13Krs3Cr9aqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU87rcDUUUUU==
X-Originating-IP: [113.102.134.146]
X-CM-SenderInfo: xolxy3pqolt0hjboyzi6rwjhhfrp/1tbiERouX1EAJxhC0wAAsF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1A6Xgjl027610

Dear Joe :

		Thanks a lot for your detail checking.


2014-02-10 



liujunliang_ljl 



å‘ä»¶äººï¼š Joe Perches 
å‘é€æ—¶é—´ï¼š 2014-02-10  13:47:08 
æ”¶ä»¶äººï¼š liujunliang_ljl 
æŠ„é€ï¼š davem; horms; romieu; gregkh; netdev; linux-usb; linux-kernel; sunhecheng 
ä¸»é¢˜ï¼š Re: [PATCH] USB2NET : SR9800 : One chip USB2.0 USB2NET SR9800Device Driver Support 
 
On Mon, 2014-02-10 at 13:33 +0800, liujunliang_ljl@163.com wrote:
> diff --git a/drivers/net/usb/sr9800.c b/drivers/net/usb/sr9800.c
[]
> + netdev_dbg(dev->net, "mac addr : 0x%x:0x%x:0x%x:0x%x:0x%x:0x%x\n",
> +    dev->net->dev_addr[0], dev->net->dev_addr[1],
> +    dev->net->dev_addr[2], dev->net->dev_addr[3],
> +    dev->net->dev_addr[4], dev->net->dev_addr[5]);
mac addresses are assumed to be hex and don't need 0x prefixes.
Also, there's a kernel vsprintf extension "%pM" for mac addresses.
netdev_dbg(dev->net, "mac addr: %pM\n", dev->net->dev_addr);
.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
