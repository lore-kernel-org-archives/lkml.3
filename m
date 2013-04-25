Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571Ab3DYUwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:52:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:46108 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758748Ab3DYUwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:52:40 -0400
Date: Thu, 25 Apr 2013 22:52:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Zhang Yi <wetpzy@163.com>
cc: linux-kernel@vger.kernel.org, dvhart@linux.intel.com, mingo@kernel.org,
        peterz@infradead.org, dave.hansen@linux.intel.com,
        "zhang.yi20@zte.com.cn" <zhang.yi20@zte.com.cn>
Subject: Re: [PATCH] futex: bugfix for futex-key conflict when futex use
 hugepage
In-Reply-To: <7ac104d6.211db.13e3c5710c9.Coremail.wetpzy@163.com>
Message-ID: <alpine.LFD.2.02.1304252247030.21884@ionos>
References: <7ac104d6.211db.13e3c5710c9.Coremail.wetpzy@163.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-62628132-1366923152=:21884"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-62628132-1366923152=:21884
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 24 Apr 2013, Zhang Yi wrote:

> Hi all,
> 
> I reworked the patch base on your advices。
> For the line-wrapped bug before, I use this mailbox to send the mail .

Unfortunately this did not work out very well.

1. Your patch now lacks a proper changelog which explains the change

2. Your patch lacks any newline characters as you can see below
 
> 
> Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>Tested-by: Ma Chenggong <ma.chenggong@zte.com.cn>Reviewed-by: Liu Dong <liu.dong3@zte.com.cn>Reviewed-by: Cui Yunfeng <cui.yunfeng@zte.com.cn>Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>Reviewed-by: Jiang Biao <jiang.biao2@zte.com.cn>
> 
> diff -uprN orig/linux3.9-rc7/include/linux/futex.h new/linux3.9-rc7/include/linux/futex.h--- orig/linux3.9-rc7/include/linux/futex.h	2013-04-15 00:45:16.000000000 +0000+++ new/linux3.9-rc7/include/linux/futex.h	2013-04-19 16:33:58.725880000 +0000@@ -19,7 +19,7 @@ handle_futex_death(u32 __user *uaddr, st  * The key type depends on whether it's a shared or private mapping.  * Don't rearrange members without looking at hash_futex().  *- * offset is aligned to a multiple of sizeof(u32) (==

Please read Documentation/SubmittingPatches and
Documentation/email-clients.txt. And as I said before: Send the mail
to yourself or a coworker and verify that it can be applied.

Thanks,

	tglx


--8323328-62628132-1366923152=:21884--
