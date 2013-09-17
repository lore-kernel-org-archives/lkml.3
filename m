Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab3IQNIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 09:08:40 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:15101 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab3IQNIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:08:39 -0400
From: Caizhiyong <caizhiyong@hisilicon.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Karel Zak <kzak@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Quyaxin <quyaxin@hisilicon.com>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: RE: [PATCH] block: support embedded device command line partition
Thread-Topic: [PATCH] block: support embedded device command line partition
Thread-Index: AQHOs5dE8N2p1FK8g0etXwnsG6H9bpnJzGAg
Date: Tue, 17 Sep 2013 13:08:24 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C07A4DA@szxeml512-mbs.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C061D75@szxeml512-mbs.china.huawei.com>
 <CACRpkdbc47jvnL9oezqH1=bYXZ8Dc9NSBv_pfnm1BzJA83bttA@mail.gmail.com>
In-Reply-To: <CACRpkdbc47jvnL9oezqH1=bYXZ8Dc9NSBv_pfnm1BzJA83bttA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.48]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> I saw this patch appear in kernel v3.12-rc1, and it's nice since it's exactly
> what we need. So needed that we proposed it in 2010:
> http://marc.info/?l=linux-kernel&m=127425650923757&w=2
> http://marc.info/?l=linux-kernel&m=127599718024364&w=2
> 
> Is this patch inspired by Ulfs patch? (I can see the code is different,
> but the cmdline argument is the same for example.) Some credit
> could have been proper in that case.

I have not searched other patch, English reading/writing is not an easy thing for me.

Thank Ulf Hansson. He was the first one who thought of this method.

> 
> Just asking: sometimes wheels do get reinvented.
> 
> Yours,
> Linus Walleij

