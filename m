Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3LPCEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 21:04:24 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:45655 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3LPCEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 21:04:23 -0500
From: Caizhiyong <caizhiyong@hisilicon.com>
To: Huang Shijie <shijie8@gmail.com>
CC: Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Quyaxin <quyaxin@hisilicon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: RE: [PATCH] mtd: increase max page/OOB size to support 16K pagesize
 NAND
Thread-Topic: [PATCH] mtd: increase max page/OOB size to support 16K
 pagesize NAND
Thread-Index: Ac73wLSIfXMFy3+HQFSy5QaQsDobRP//q3wA//9efLCAARnBgP/7q/tw
Date: Mon, 16 Dec 2013 02:03:54 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F25E47627@SZXEMA512-MBX.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F25E47455@SZXEMA512-MBX.china.huawei.com>
 <20131213080118.GC24650@norris-Latitude-E6410>
 <C3050A4DBA34F345975765E43127F10F25E47537@SZXEMA512-MBX.china.huawei.com>
 <20131213151138.GA1316@gmail.com>
In-Reply-To: <20131213151138.GA1316@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.53]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > There are a lot of 16K page size NAND, they are used in android system.
> >
> > Many NAND need read retry and data randomization, kernel does not support this
> feature.
> Brian is adding the read-retry feature.
> 
> I think the data randomization should be done by the hardware.
> If we do it by software, it costs lot of the cpu cycles.
>
> 
> > Kernel also does not support synchronous NAND.
> 
> The synchronous NAND should be supported by the nand controller driver,
> not the kernel.

Yes. Those feature should be support by NAND controller hardware and driver.
But the driver does not know what NAND should use those feature.
Perhaps, the NAND id table, should add something.

Looking forward to your feedback.
Best regards.
Cai Zhiyong.
