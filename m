Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab3J3BBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 21:01:50 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57486 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751292Ab3J3BBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 21:01:49 -0400
Date: Wed, 30 Oct 2013 00:49:27 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 5/7] arm64, jump label: detect %c support for ARM64
Message-ID: <20131030004927.GD25346@mudshark.cambridge.arm.com>
References: <1382109602-27432-1-git-send-email-liuj97@gmail.com>
 <1382109602-27432-6-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382109602-27432-6-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 04:19:59PM +0100, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> As commit a9468f30b5eac6 "ARM: 7333/2: jump label: detect %c
> support for ARM", this patch detects the same thing for ARM64
> because some ARM64 GCC versions have the same issue.
> 
> Some versions of ARM64 GCC which do support asm goto, do not
> support the %c specifier. Since we need the %c to support jump
> labels on ARM64, detect that too in the asm goto detection script
> to avoid build errors with these versions.

Acked-by: Will Deacon <will.deacon@arm.com>

The toolchain is being fixed upstream for this, but we should have the check
for older versions.

Will
