Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaCYJNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 05:13:20 -0400
Received: from m13-127.163.com ([220.181.13.127]:37380 "EHLO m13-127.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbaCYJNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 05:13:16 -0400
X-Greylist: delayed 928 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2014 05:13:15 EDT
X-Originating-IP: [202.108.100.231]
Date: Tue, 25 Mar 2014 16:56:20 +0800 (CST)
From: "wei zhang" <asuka.com@163.com>
To: "David Miller" <davem@davemloft.net>
Cc: xeb@mail.ru, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: gre: Fix null pointer dereference in
 gre_cisco_err()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version SP_ntes V3.5 build
 20131204(24406.5820.5783) Copyright (c) 2002-2014 www.mailtech.cn 163com
In-Reply-To: <20140324.151417.474668383309974516.davem@davemloft.net>
References: <1395646471-637-1-git-send-email-asuka.com@163.com>
 <20140324.151417.474668383309974516.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <232812eb.b291.144f87462d4.Coremail.asuka.com@163.com>
X-CM-TRANSID: f8GowEDJZEC1RDFT2q0bAA--.1106W
X-CM-SenderInfo: 5dvxytoofrzqqrwthudrp/1tbiMhlZ1lD-rjrikwACss
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2P9EA5Q020222

AtÂ 2014-03-25Â 03:14:17,"DavidÂ Miller"Â <davem@davemloft.net>Â wrote:
>From:Â WeiÂ ZhangÂ <asuka.com@163.com>
>Date:Â Mon,Â 24Â MarÂ 2014Â 15:34:31Â +0800
>
>>Â WhenÂ useÂ theÂ greÂ vport,Â openvswitchÂ registerÂ aÂ gre_cisco_protocolÂ but
>>Â doesÂ notÂ supplyÂ aÂ err_handlerÂ withÂ it.Â TheÂ gre_cisco_err()Â callÂ the
>>Â err_handlerÂ withoutÂ existenceÂ check,Â causeÂ theÂ kernelÂ crash.
>>Â 
>>Â ThisÂ patchÂ baseÂ onÂ v3.14-rc7.Â ButÂ theÂ bugÂ affectÂ allÂ kernelÂ newerÂ than
>>Â 3.11!
>>Â 
>>Â Signed-off-by:Â WeiÂ ZhangÂ <asuka.com@163.com>
>
>Rather,Â openvswitchÂ shouldÂ provideÂ anÂ appropriateÂ ->err_handler()Â that
>returnsÂ PACKET_RCVDÂ orÂ PACKET_REJECT.

Thank you for your explanation, I misunderstand it .
I'm very sorry about this bothering!

>
>I'mÂ notÂ applyingÂ thisÂ patch.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
