Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab3KYBUG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 20:20:06 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36537 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab3KYBUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 20:20:03 -0500
Date: Sun, 24 Nov 2013 19:20:00 -0600
From: rkuo <rkuo@codeaurora.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: hexagon: include: asm: add "vga.h" in Kbuild
Message-ID: <20131125012000.GC18921@codeaurora.org>
References: <528AF461.4020502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528AF461.4020502@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 01:17:21PM +0800, Chen Gang wrote:
> Need include generic "vga.h", or can not pass compiling with
> allmodconfig, the related error:
> 
>     CC [M]  drivers/gpu/drm/drm_irq.o
>   In file included from include/linux/vgaarb.h:34:0,
>                    from drivers/gpu/drm/drm_irq.c:42:
>   include/video/vga.h:22:21: fatal error: asm/vga.h: No such file or directory
> 
> Also move "preempt.h" upper to match sort order.
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/hexagon/include/asm/Kbuild |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 

Acked-by: Richard Kuo <rkuo@codeaurora.org>

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
