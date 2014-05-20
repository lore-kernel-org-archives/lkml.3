Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaETX6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 19:58:17 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37688 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaETX6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 19:58:14 -0400
Date: Tue, 20 May 2014 18:58:07 -0500
From: rkuo <rkuo@codeaurora.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Chen Gang <gang.chen.5i5j@gmail.com>, linux-hexagon@vger.kernel.org
Subject: Re: [PATCH 11/27] hexagon: Use common bits from generic tlb.h
Message-ID: <20140520235807.GE12698@codeaurora.org>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
 <1400093999-18703-12-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400093999-18703-12-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 08:59:43PM +0200, Richard Weinberger wrote:
> It is no longer needed to define them on our own.
> 
> Cc: Richard Kuo <rkuo@codeaurora.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Chen Gang <gang.chen.5i5j@gmail.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: linux-hexagon@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/hexagon/include/asm/Kbuild |  1 +
>  arch/hexagon/include/asm/tlb.h  | 39 ---------------------------------------
>  2 files changed, 1 insertion(+), 39 deletions(-)
>  delete mode 100644 arch/hexagon/include/asm/tlb.h
> 

Worked for Hexagon, thanks.

Acked-by: Richard Kuo <rkuo@codeaurora.org>

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
