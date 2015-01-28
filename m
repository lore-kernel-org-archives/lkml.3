Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbbA2BH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:07:56 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:35194 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbbA2BHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:07:53 -0500
MIME-Version: 1.0
In-Reply-To: <1404458911-8214-2-git-send-email-takahiro.akashi@linaro.org>
References: <1404458911-8214-1-git-send-email-takahiro.akashi@linaro.org>
	<1404458911-8214-2-git-send-email-takahiro.akashi@linaro.org>
Date: Wed, 28 Jan 2015 15:31:49 -0600
Message-ID: <CAOZdJXUhpmi0SM5izDYQnx8SHjWjqOFVduV0+boPw6+YCKP5+g@mail.gmail.com>
Subject: Re: [PATCH v10 1/3] arm64: Add __NR_* definitions for compat syscalls
From: Timur Tabi <timur@codeaurora.org>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, eparis@redhat.com, rgb@redhat.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linaro-kernel@lists.linaro.org,
        Deepak Saxena <dsaxena@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-audit@redhat.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2014 at 2:28 AM, AKASHI Takahiro
<takahiro.akashi@linaro.org> wrote:
> +#define __ARM_NR_COMPAT_BASE           0x0f0000
> +#define __ARM_NR_compat_cacheflush     (__ARM_NR_COMPAT_BASE+2)
> +#define __ARM_NR_compat_set_tls                (__ARM_NR_COMPAT_BASE+5)

I know this patch is six months old, but I was wondering if anyone
knows of any plans to make these syscalls available to 64-bit apps?
We have a 32-bit app that uses __ARM_NR_compat_cacheflush, and we'd
like to port that app to 64-bit.  I'm just not sure how to start doing
that, since there don't appear to be any 64-bit ARM-specific syscalls.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
