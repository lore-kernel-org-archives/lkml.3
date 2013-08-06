Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab3HFK4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:56:00 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:7631 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab3HFKz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:55:59 -0400
From: Caizhiyong <caizhiyong@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Karel Zak <kzak@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@huawei.com>,
        Quyaxin <quyaxin@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        David Woodhouse <dwmw2@infradead.org>, Marius Groeger <mag@sysgo.de>
Subject: RE: [PATCH] block: support embedded device command line partition
Thread-Topic: [PATCH] block: support embedded device command line partition
Thread-Index: Ac6QL80+CfVf2IEATPuoaFA0S7oaSQBt1xAAACqo5KA=
Date: Tue, 6 Aug 2013 10:53:01 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C061F3D@szxeml512-mbs.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C061D75@szxeml512-mbs.china.huawei.com>
 <20130805152206.76462cc4a42e51b16a0532f1@linux-foundation.org>
In-Reply-To: <20130805152206.76462cc4a42e51b16a0532f1@linux-foundation.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Tuesday, August 06, 2013 6:22 AM
> To: Caizhiyong
> Cc: Karel Zak; linux-kernel@vger.kernel.org; Wanglin (Albert); Quyaxin; Jens Axboe;
> David Woodhouse; Marius Groeger
> Subject: Re: [PATCH] block: support embedded device command line partition
> 
> On Sat, 3 Aug 2013 09:57:04 +0000 Caizhiyong <caizhiyong@huawei.com> wrote:
> 
> > From: Cai Zhiyong <caizhiyong@huawei.com>
> >
> > Read block device partition table from command line.
> > The partition used for fixed block device (eMMC) embedded device.
> > It is no MBR, save storage space. Bootloader can be easily accessed by
> > absolute address of data on the block device.
> > Users can easily change the partition.
> >
> > This code reference MTD partition, source "drivers/mtd/cmdlinepart.c"
> > About the partition verbose reference
> "Documentation/block/cmdline-partition.txt"
> >
> 
> Seems OK to me.
> 
> The obvious question is: can we consolidate this with
> drivers/mtd/cmdlinepart.c in some fashion so the kernel doesn't have
> two parsers which do the same thing?

I will move the parser to "lib/cmdline.c".

Looking forward to your feedback.
Best regards,
Cai Zhiyong.

http://www.huawei.com
