Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbaELR2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:28:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42175 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaELR2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:28:34 -0400
Date: Mon, 12 May 2014 12:28:26 -0500
From: rkuo <rkuo@codeaurora.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Vineet Gupta <vgupta@synopsys.com>
Subject: Re: [PATCH 08/20] arch,hexagon: Fold atomic_ops
Message-ID: <20140512172826.GA12698@codeaurora.org>
References: <20140508135840.956784204@infradead.org>
 <20140508135852.171567636@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508135852.171567636@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 03:58:48PM +0200, Peter Zijlstra wrote:
> OK, no LoC saved in this case because the !return variants were
> defined in terms of the return ops. Still do it because this also
> prepares for easy addition of new ops.
> 
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Richard Kuo <rkuo@codeaurora.org>
> Cc: Vineet Gupta <vgupta@synopsys.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/hexagon/include/asm/atomic.h |   68 ++++++++++++++++++++------------------
>  1 file changed, 37 insertions(+), 31 deletions(-)
> 

Acked-by: Richard Kuo <rkuo@codeaurora.org>

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
