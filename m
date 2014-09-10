Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbaIJBqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 21:46:36 -0400
Received: from m13-98.163.com ([220.181.13.98]:43094 "EHLO m13-98.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbaIJBqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 21:46:34 -0400
X-Greylist: delayed 908 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 21:46:33 EDT
X-Originating-IP: [210.13.71.68]
Date: Wed, 10 Sep 2014 09:30:47 +0800 (CST)
From: "Chao Xie" <xiechao_mail@163.com>
To: "Mike Turquette" <mturquette@linaro.org>
Cc: "Chao Xie" <chao.xie@marvell.com>, haojian.zhuang@gmail.com,
        haojian.zhuang@linaro.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re:Re: [PATCH 02/12] clk: mmp: add spin lock for clk-frac
X-Priority: 3
X-Mailer: Coremail Webmail Server Version SP_ntes V3.5 build
 20140725(28226.6623) Copyright (c) 2002-2014 www.mailtech.cn 163com
In-Reply-To: <20140903180424.11368.36053@quantum>
References: <1409027904-21859-1-git-send-email-chao.xie@marvell.com>
 <1409027904-21859-3-git-send-email-chao.xie@marvell.com>
 <20140903180424.11368.36053@quantum>
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <39edaf46.1299c.1485d2f33e4.Coremail.xiechao_mail@163.com>
X-CM-TRANSID: YsGowAD3OurIqQ9UB8+IAA--.60387W
X-CM-SenderInfo: p0lhux5drbztllo6il2tof0z/1tbiqwP8F1EAMfH5FgABs8
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8A1keRx011543


At 2014-09-04 02:04:24, "Mike Turquette" <mturquette@linaro.org> wrote:
>Quoting Chao Xie (2014-08-25 21:38:14)
>> From: Chao Xie <chao.xie@marvell.com>
>> 
>> The register used by clk-frac may be shared with
>> other clocks.
>> So it needs to use spin lock to protect the register
>> access.
>> 
>> Signed-off-by: Chao Xie <chao.xie@marvell.com>
>
>This patch will break against the latest clk-next due to api changes.
>You can see more here[0] and use this script to update your code if you
>like[1].
>
>Basically the calls to clk_set_rate need to be changed to
>clk_provider_set_rate.

>
I see the patch set [0] is V10 now, and it is not merged to clk-next yet.
So should i wait for the patch set to be merged, then send out the updated patches?

>[0] http://lkml.kernel.org/r/<1409758148-20104-1-git-send-email-tomeu.vizoso@collabora.com>
>[1] http://cgit.collabora.com/git/user/tomeu/linux.git/commit/?h=clk-refactoring-9&id=ea48c0d655346cce26329523cf24574f9ea8feee
>
>Regards,
>Mike
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
