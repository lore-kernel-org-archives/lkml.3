Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaB1Q6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:58:55 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55190 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752593AbaB1Q6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:58:54 -0500
Date: Fri, 28 Feb 2014 16:58:17 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "wad@chromium.org" <wad@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] arm64: is_compat_task is defined both in
 asm/compat.h and linux/compat.h
Message-ID: <20140228165817.GE30996@mudshark.cambridge.arm.com>
References: <1391767892-5395-1-git-send-email-takahiro.akashi@linaro.org>
 <1393320025-2855-1-git-send-email-takahiro.akashi@linaro.org>
 <1393320025-2855-4-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393320025-2855-4-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 09:20:25AM +0000, AKASHI Takahiro wrote:
> kernel/seccomp.c includes linux/compat.h and, indicrectly, asm/compat.h
> via asm/syscall.h. Due to the duplicated definitions of is_compat_task,
> compiling this file will fail in the case of !CONFIG_COMPAT.
> So this patch
> 1) removes is_compat_task() definition from asm/compat.h
> 2) replaces asm/compat.h to linux/compat.h in kernel/*.c
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---

You built this, right? If so,

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
