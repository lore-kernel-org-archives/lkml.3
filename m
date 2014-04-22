Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbaDVVcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:32:13 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:44382 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757948AbaDVVcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:32:10 -0400
Date: Tue, 22 Apr 2014 22:31:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Liu Hua <sdu.liu@huawei.com>
Cc: nicolas.pitre@linaro.org, will.deacon@arm.com, vitalya@ti.com,
        cyril@ti.com, santosh.shilimkar@ti.com, lauraa@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wangnan0@huawei.com, peifeiyue@huawei.com, liusdu@126.co
Subject: Re: [PATCH v3 0/2] change ARM linux memory layout to support 32
	CPUs
Message-ID: <20140422213114.GA24070@n2100.arm.linux.org.uk>
References: <1397559967-26050-1-git-send-email-sdu.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397559967-26050-1-git-send-email-sdu.liu@huawei.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 07:06:05PM +0800, Liu Hua wrote:
> This patch series change fixmap mapping region to suppport 32 CPUs.
> Because the "top_pmd" covers 0xfffe0000 - 0xffffffff(2M). And part 
> is used by vector table. So I move this region down to 0xffc00000
>  - 0xffdffff. 

Can you explain why you have submitted these patches to my patch tracker
with a copy to stable@vger.kernel.org ?

What makes these qualify for stable tree inclusion?  What regression are
they fixing?

We don't put patches into the stable tree for things that /never/ worked
in the past.  We've never supported 32 CPUs so I don't think these
qualify.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
