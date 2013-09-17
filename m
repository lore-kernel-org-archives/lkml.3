Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab3IQLPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 07:15:50 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:47688 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab3IQLPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 07:15:47 -0400
MIME-Version: 1.0
In-Reply-To: <C3050A4DBA34F345975765E43127F10F1C061D75@szxeml512-mbs.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C061D75@szxeml512-mbs.china.huawei.com>
Date: Tue, 17 Sep 2013 13:15:46 +0200
Message-ID: <CACRpkdbc47jvnL9oezqH1=bYXZ8Dc9NSBv_pfnm1BzJA83bttA@mail.gmail.com>
Subject: Re: [PATCH] block: support embedded device command line partition
From: Linus Walleij <linus.walleij@linaro.org>
To: Caizhiyong <caizhiyong@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Karel Zak <kzak@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@huawei.com>,
        Quyaxin <quyaxin@huawei.com>, Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 3, 2013 at 11:57 AM, Caizhiyong <caizhiyong@huawei.com> wrote:

> From: Cai Zhiyong <caizhiyong@huawei.com>
>
> Read block device partition table from command line.
> The partition used for fixed block device (eMMC) embedded device.
> It is no MBR, save storage space. Bootloader can be easily accessed by
> absolute address of data on the block device.
> Users can easily change the partition.
>
> This code reference MTD partition, source "drivers/mtd/cmdlinepart.c"
> About the partition verbose reference "Documentation/block/cmdline-partition.txt"
>
> Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>

I saw this patch appear in kernel v3.12-rc1, and it's nice since it's exactly
what we need. So needed that we proposed it in 2010:
http://marc.info/?l=linux-kernel&m=127425650923757&w=2
http://marc.info/?l=linux-kernel&m=127599718024364&w=2

Is this patch inspired by Ulfs patch? (I can see the code is different,
but the cmdline argument is the same for example.) Some credit
could have been proper in that case.

Just asking: sometimes wheels do get reinvented.

Yours,
Linus Walleij
