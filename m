Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaBGDN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 22:13:59 -0500
Received: from m12-15.163.com ([220.181.12.15]:42549 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaBGDN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 22:13:57 -0500
Date: Fri, 7 Feb 2014 11:13:07 +0800
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
References: <1390898200-9925-1-git-send-email-liujunliang_ljl@163.com>,
 <1390899572.20150.97.camel@joe-AO722>
Subject: =?utf-8?B?UmU6IFJlOiBbUEFUQ0hdIFVTQjJORVQgOiBTUjk4MDAgOiBPbmUgY2hpcCBVU0IyLjAgVVNCMk5FVCBTUjk4MDBEZXZpY2UgRHJpdmVyIFN1cHBvcnQ=?=
Message-ID: <201402071113053122628@163.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
X-CM-TRANSID: D8CowECZDUA_T_RSiTeuAQ--.487S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KryUtw4fAr4fGw4rAryrWFg_yoW8XrWkpa
	s7KF1Fyws7Wr13tw1avrs5G3s8Xr4UG343Way5KrWFvF1DZr93Gan8W34jg3W7KryrAw1Y
	vw4jvay7uws5urJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07je385UUUUU=
X-Originating-IP: [119.123.180.76]
X-CM-SenderInfo: xolxy3pqolt0hjboyzi6rwjhhfrp/1tbiLwQqX1EAJxK96QABsv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s173EEYQ009553

Dear Joe ï¼š

		I'm sorry that I reply so late, because I have just spent new chinese year.

		I will resubmit SR9800 Driver today.

		Thanks a lot.


2014-02-07 



liujunliang_ljl 



å‘ä»¶äººï¼š Joe Perches 
å‘é€æ—¶é—´ï¼š 2014-01-28  16:59:38 
æ”¶ä»¶äººï¼š liujunliang_ljl 
æŠ„é€ï¼š davem; horms; romieu; gregkh; netdev; linux-usb; linux-kernel; sunhecheng 
ä¸»é¢˜ï¼š Re: [PATCH] USB2NET : SR9800 : One chip USB2.0 USB2NET SR9800Device Driver Support 
 
On Tue, 2014-01-28 at 16:36 +0800, liujunliang_ljl@163.com wrote:
> From: Liu Junliang <liujunliang_ljl@163.com>
trivial comments...
> diff --git a/drivers/net/usb/sr9800.c b/drivers/net/usb/sr9800.c
[]
> +static int sr_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
> +{
[]
> + if (size != ((~header >> 16) & 0x07ff)) {
> + netdev_err(dev->net,
> +    "sr_rx_fixup() Bad Header Length\n");
printks with embedded functions names are
generally better using "%s: ", __func__
netdev_err(dev->net, "%s: Bad header length\n",
   __func__);
[]
> + netdev_err(dev->net,
> +    "sr_rx_fixup() Bad RX Length %d\n", size);
etc.
> + if (skb->len != offset) {
> + netdev_err(dev->net, "sr_rx_fixup() Bad SKB Length %d\n",
> +    skb->len);
etc.
[]
> +static inline int sr9800_set_default_mode(struct usbnet *dev)
> +{
rather a big function to inline
[]
> + if (ret < 0) {
> + netdev_dbg(dev->net, "Write IPG,IPG1,IPG2 failed: %d", ret);
missing newline terminations
> + netdev_dbg(dev->net, "RX_CTL is 0x%04x after all initializations",
> +    rx_ctl);
etc...
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
