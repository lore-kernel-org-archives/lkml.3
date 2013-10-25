Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab3JYLxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:53:33 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:64383 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab3JYLxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:53:32 -0400
From: Caizhiyong <caizhiyong@hisilicon.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>
CC: "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Quyaxin <quyaxin@hisilicon.com>
Subject: RE: [PATCH] mtd: cmdlinepart: use cmdline partition parser lib
Thread-Topic: [PATCH] mtd: cmdlinepart: use cmdline partition parser lib
Thread-Index: AQHOzY99LAHuHYI9bEi/n4n0UmETuJoFUGTQ
Date: Fri, 25 Oct 2013 11:52:14 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C084F26@szxeml512-mbs.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C0643B8@szxeml512-mbx.china.huawei.com>
 <20131020120603.GA18678@localhost>
In-Reply-To: <20131020120603.GA18678@localhost>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.21]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9PBrdYw024689

> 
> I'd like to review the patch in detail and test it, but being a bit old,
> the patch doesn't apply as it is on v3.12-rc5. Care to resend an update?
>
  I have sent you a 2 patch base on v3.12-rc6. Are there any problems? I tested it for a long time and found no problems.

  Are there any plans for supporting synchronous NAND in the future?

 
> Brian: I saw you want to move forward with this. I guess we can give
> it a test, and if all the possible 'mtdparts' use cases work, then
> we shouldn't object the cleanup, right?
> --
> Ezequiel GarcÃ­a, Free Electrons
> Embedded Linux, Kernel and Android Engineering
> http://free-electrons.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
