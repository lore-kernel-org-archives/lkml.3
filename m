Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaAKUK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 15:10:26 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55429 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbaAKUKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 15:10:23 -0500
Date: Sat, 11 Jan 2014 12:10:19 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <b32955@freescale.com>, Caizhiyong <caizhiyong@hisilicon.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: Re: [PATCH] mtd: nand:  assign mtd->name in find_full_id_nand
Message-ID: <20140111201019.GD1992@norris-Latitude-E6410>
References: <C3050A4DBA34F345975765E43127F10F25E47E20@SZXEMA512-MBX.china.huawei.com>
 <20131226021937.GA6752@shlinux2.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131226021937.GA6752@shlinux2.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 26, 2013 at 10:19:39AM +0800, Huang Shijie wrote:
> On Thu, Dec 26, 2013 at 01:51:58AM +0000, Caizhiyong wrote:
> > From: Cai Zhiyong <caizhiyong@huawei.com>
> > Date: Wed, 25 Dec 2013 21:19:21 +0800
> > Subject: [PATCH] mtd: nand: assign mtd->name in find_full_id_nand
> > 
> > This patch assigned the type->name to mtd->name when mtd->name is
> > NULL in function "find_full_id_nand".
> > mtd->name is NULL may cause some problem.
> > 
> > Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
> Acked-by: Huang Shijie <b32955@freescale.com>

Thanks, the patch looks good. Pushed to l2-mtd.git.

Wouldn't this trigger an exception when reading
/sys/class/mtd/mtdX/name? If so, should this be marked for stable?

Brian
