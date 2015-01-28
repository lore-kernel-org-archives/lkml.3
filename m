Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbbA1UWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:22:45 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43727 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394AbbA1UWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:22:42 -0500
Message-ID: <54C94511.30508@codeaurora.org>
Date: Wed, 28 Jan 2015 12:22:41 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 0/2] Fix secondary CPU boot for thumb2 kernels
References: <1421869698-27341-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1421869698-27341-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/15 11:48, Stephen Boyd wrote:
> Currently I can't boot up secondary CPUs on qcom platforms when I
> compile the kernel for THUMB2 mode. This is because we always enter
> the kernel in ARM mode regardless of what mode the kernel is compiled
> for. This patchset adds a small wrapper to secondary_startup() called
> secondary_startup_arm() that allows us to switch into THUMB2 mode if
> we need to. If the kernel is compiled for ARM mode it shouldn't have
> any effect.
>
> Stephen Boyd (2):
>   ARM: Add a secondary_startup that assumes ARM mode
>   ARM: qcom: Use secondary_startup_arm()
>
>  arch/arm/kernel/head.S       | 7 +++++++
>  arch/arm/mach-qcom/platsmp.c | 4 ++--
>  2 files changed, 9 insertions(+), 2 deletions(-)
>

Any comments here? Perhaps I can send this through the patch tracker?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

