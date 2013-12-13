Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab3LMPLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:11:50 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:62282 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab3LMPLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:11:49 -0500
Date: Fri, 13 Dec 2013 23:11:39 +0800
From: Huang Shijie <shijie8@gmail.com>
To: Caizhiyong <caizhiyong@hisilicon.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Quyaxin <quyaxin@hisilicon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] mtd: increase max page/OOB size to support 16K pagesize
 NAND
Message-ID: <20131213151138.GA1316@gmail.com>
References: <C3050A4DBA34F345975765E43127F10F25E47455@SZXEMA512-MBX.china.huawei.com>
 <20131213080118.GC24650@norris-Latitude-E6410>
 <C3050A4DBA34F345975765E43127F10F25E47537@SZXEMA512-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C3050A4DBA34F345975765E43127F10F25E47537@SZXEMA512-MBX.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 11:10:10AM +0000, Caizhiyong wrote:
> 
> There are a lot of 16K page size NAND, they are used in android system.
> 
> Many NAND need read retry and data randomization, kernel does not support this feature.
Brian is adding the read-retry feature.

I think the data randomization should be done by the hardware.
If we do it by software, it costs lot of the cpu cycles.


> Kernel also does not support synchronous NAND.

The synchronous NAND should be supported by the nand controller driver,
not the kernel.


thanks
Huang Shijie
