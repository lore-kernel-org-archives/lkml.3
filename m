Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3C3MWc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 08:22:32 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:60011 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab3C3MWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 08:22:30 -0400
Date: Sat, 30 Mar 2013 13:22:24 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: davem@davemloft.net, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Guohanjun (Hanjun Guo)" <guohanjun@huawei.com>, wangyijing@huawei.com
Subject: Re: [PATCH] sparc:cleanup unused code in smp_32.h
Message-ID: <20130330122224.GA10294@merkur.ravnborg.org>
References: <5156BE4A.2030400@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5156BE4A.2030400@huawei.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 30, 2013 at 06:28:26PM +0800, Kefeng Wang wrote:
> After genirq and generic clockevent support at sparc32,
> smp4m_irq_rotate(), prof_multiplier() and prof_counter()
> are no longer used and should be removed.
> 
> Find more info from commit 6baa9b20 & 62f08283.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
