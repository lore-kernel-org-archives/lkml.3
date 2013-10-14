Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab3JNNz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:55:58 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54274 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750906Ab3JNNz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:55:57 -0400
Date: Mon, 14 Oct 2013 14:54:58 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH v2 1/4] arm64: fix possible invalid FPSIMD
 initialization state
Message-ID: <20131014135457.GE7682@arm.com>
References: <1381674029-430-1-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381674029-430-1-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 03:20:17PM +0100, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> If context switching happens during executing fpsimd_flush_thread(),
> stale value in FPSIMD registers will be saved into current thread's
> fpsimd_state by fpsimd_thread_switch(). That may cause invalid
> initialization state for the new process, so disable preemption
> when executing fpsimd_flush_thread().
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Jiang Liu <liuj97@gmail.com>

That's already in mainline (3.12-rc4).

-- 
Catalin
