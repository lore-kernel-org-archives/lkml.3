Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab3KLOFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:05:43 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:55484 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab3KLOFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:05:41 -0500
Date: Tue, 12 Nov 2013 22:03:57 -0500
From: Huang Shijie <shijie8@gmail.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Caizhiyong <caizhiyong@hisilicon.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karel Zak <kzak@redhat.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH 2/2] mtd: cmdlinepart: support master name is not set
 when parser partition
Message-ID: <20131113030351.GA8465@gmail.com>
References: <C3050A4DBA34F345975765E43127F10F1C08B3EA@szxeml512-mbs.china.huawei.com>
 <20131111030657.GA9406@gmail.com>
 <20131110180900.GA2478@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131110180900.GA2478@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 10, 2013 at 03:09:02PM -0300, Ezequiel Garcia wrote:
> 
> Can you summarize such cases? Or maybe better, just share them all :)
I just test it with cases such as(my nand is just 1G):
   (1) mtdparts=gpmi-nand:16m(boot),16m(kernel),600m(dtb),600m(ok),-(rootfs)
   (2) mtdparts=gpmi-nand:16m(boot),16m(kernel),600m(ok),-(rootfs)
   (3) mtdparts=gpmi-nand:16m(boot),16m(kernel),600m(dtb),600m(ok),600m(ok2),-(rootfs)

thanks
Huang Shijie
