Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab3KHKJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:09:38 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:41188 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab3KHKJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:09:37 -0500
From: Caizhiyong <caizhiyong@hisilicon.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karel Zak <kzak@redhat.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: RE: [PATCH 2/2]  mtd: cmdlinepart: use cmdline partition parser lib
Thread-Topic: [PATCH 2/2]  mtd: cmdlinepart: use cmdline partition parser lib
Thread-Index: AQHOzyiczXccMKf72E2y9hcK5+vClpoWzHYAgAQyg5D//6JCgIAAj5oA
Date: Fri, 8 Nov 2013 09:58:19 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C08B2F6@szxeml512-mbs.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C0643B8@szxeml512-mbx.china.huawei.com>
 <20131020120603.GA18678@localhost>
 <C3050A4DBA34F345975765E43127F10F1C084C81@szxeml512-mbs.china.huawei.com>
 <20131105144328.fb5a6a1d423776b324771706@linux-foundation.org>
 <C3050A4DBA34F345975765E43127F10F1C08B274@szxeml512-mbs.china.huawei.com>
 <20131108091216.GA2365@localhost>
In-Reply-To: <20131108091216.GA2365@localhost>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.36]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rA8A9ipU005959

> Such results was never posted and unless we see those, I think
> I'd rather NACK this patch instead. I like the cleanup, but only
> if it's guaranteed to _not_ brake things, specially when dealing
> with a kernel parameter.

Do you have some test case or test standard for me perform.

> --
> Ezequiel GarcÃ­a, Free Electrons
> Embedded Linux, Kernel and Android Engineering
> http://free-electrons.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
