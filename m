Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab3LMIEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:04:49 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:38222 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3LMIEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:04:48 -0500
Date: Fri, 13 Dec 2013 00:04:44 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: Caizhiyong <caizhiyong@hisilicon.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Quyaxin <quyaxin@hisilicon.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] mtd: increase max page/OOB size to support 16K pagesize
 NAND
Message-ID: <20131213080444.GD24650@norris-Latitude-E6410>
References: <C3050A4DBA34F345975765E43127F10F25E47455@SZXEMA512-MBX.china.huawei.com>
 <20131213072705.GA28525@shlinux2.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213072705.GA28525@shlinux2.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 03:27:12PM +0800, Huang Shijie wrote:
> On Fri, Dec 13, 2013 at 05:03:49AM +0000, Caizhiyong wrote:
> > --- a/include/linux/mtd/nand.h
> > +++ b/include/linux/mtd/nand.h
> > @@ -56,8 +56,8 @@ extern int nand_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len);
> >   * is supported now. If you add a chip with bigger oobsize/page
> >   * adjust this accordingly.
> >   */
> > -#define NAND_MAX_OOBSIZE	744
> > -#define NAND_MAX_PAGESIZE	8192
> > +#define NAND_MAX_OOBSIZE	1280
> > +#define NAND_MAX_PAGESIZE	16384
> maybe it is time to remove these two macros.

It's like you read my mind :)

Brian
