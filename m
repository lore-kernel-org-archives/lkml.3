Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaHUAGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 20:06:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33026 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbaHUAGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 20:06:35 -0400
Date: Wed, 20 Aug 2014 19:06:29 -0500
From: rkuo <rkuo@codeaurora.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Vineet Gupta <vgupta@synopsys.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        Noam Camus <noamc@ezchip.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tony Lu <zlu@tilera.com>, Kirill Tkhai <tkhai@yandex.ru>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QUALCOMM HEXAGON..." <linux-hexagon@vger.kernel.org>,
        "open list:SUPERH" <linux-sh@vger.kernel.org>,
        "open list:TENSILICA XTENSA..." <linux-xtensa@linux-xtensa.org>
Subject: Re: [PATCH v2] flush_icache_range: Export symbol to fix build errors
Message-ID: <20140821000629.GB6040@codeaurora.org>
References: <1408377559-30775-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408377559-30775-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 11:59:13AM -0400, Pranith Kumar wrote:
> Fix building errors occuring due to a missing export of flush_icache_range() in
> 
> kisskb.ellerman.id.au/kisskb/buildresult/11677809/
> 
> ERROR: "flush_icache_range" [drivers/misc/lkdtm.ko] undefined!
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Andrew Morton <akpm@linux-foundation.org>
> ---
>  arch/arc/mm/cache_arc700.c | 1 +
>  arch/hexagon/mm/cache.c    | 1 +
>  arch/sh/mm/cache.c         | 1 +
>  arch/tile/kernel/smp.c     | 1 +
>  arch/xtensa/kernel/smp.c   | 1 +
>  5 files changed, 5 insertions(+)
> 

For Hexagon,

Acked-by: Richard Kuo <rkuo@codeaurora.org>

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
