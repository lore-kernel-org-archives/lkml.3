Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098Ab3CECn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 21:43:56 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52674 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758979Ab3CECny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 21:43:54 -0500
Date: Tue, 5 Mar 2013 02:43:39 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: perf: Fix section mismatch on armpmu_init()
Message-ID: <20130305024338.GA17735@mudshark.cambridge.arm.com>
References: <1362438937-28143-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362438937-28143-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 11:15:37PM +0000, Stephen Boyd wrote:
> WARNING: vmlinux.o(.text+0xfb80): Section mismatch in reference
> from the function armpmu_register() to the function
> .init.text:armpmu_init()
> The function armpmu_register() references
> the function __init armpmu_init().
> This is often because armpmu_register lacks a __init
> annotation or the annotation of armpmu_init is wrong.
> 
> Just drop the __init marking on armpmu_init() because
> armpmu_register() no longer has an __init marking.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Cheers Stephen:

  Acked-by: Will Deacon <will.deacon@arm.com>

Can you put this into the patch system please?

Will
