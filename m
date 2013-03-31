Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab3CaXbg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 19:31:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49770 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab3CaXbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 19:31:35 -0400
Date: Sun, 31 Mar 2013 19:31:33 -0400 (EDT)
Message-Id: <20130331.193133.210545164355686346.davem@davemloft.net>
To: wangkefeng.wang@huawei.com
Cc: sam@ravnborg.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        guohanjun@huawei.com, wangyijing@huawei.com
Subject: Re: [PATCH] sparc:cleanup unused code in smp_32.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <5156BE4A.2030400@huawei.com>
References: <5156BE4A.2030400@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 31 Mar 2013 16:31:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>
Date: Sat, 30 Mar 2013 18:28:26 +0800

> After genirq and generic clockevent support at sparc32,
> smp4m_irq_rotate(), prof_multiplier() and prof_counter()
> are no longer used and should be removed.
> 
> Find more info from commit 6baa9b20 & 62f08283.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Applied.
