Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3C2LJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 07:09:10 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:15272 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab3C2LJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 07:09:08 -0400
Date: Fri, 29 Mar 2013 12:09:04 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: davem@davemloft.net, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc:remove unused declaration smp_boot_cpus()
Message-ID: <20130329110904.GA2765@merkur.ravnborg.org>
References: <5152E41D.2030901@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5152E41D.2030901@huawei.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 08:20:45PM +0800, Kefeng Wang wrote:
> smp_boot_cpus() was replaced smp_prepare_cpus() long ago, and it no
> longer needed, so delete it.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

But when looking at the same file it looks like we have
more candidates for removal:
smp4m_irq_rotate,
prof_multiplier,
prof_counter,

Care to send a follow-up patch that remvoe these also.

	Sam
