Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761999Ab3JPS0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:26:41 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33285 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761286Ab3JPS0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:26:39 -0400
Date: Wed, 16 Oct 2013 11:26:37 -0700
From: David Brown <davidb@codeaurora.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ARM: debug: msm: Add DEBUG_LL support for
 ARCH_MSM8974
Message-ID: <20131016182637.GA21292@codeaurora.org>
References: <1380841557-2673-1-git-send-email-rvaswani@codeaurora.org>
 <1380841557-2673-4-git-send-email-rvaswani@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1380841557-2673-4-git-send-email-rvaswani@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 04:05:56PM -0700, Rohit Vaswani wrote:
>Add debug uart support for MSM8974. This patch adds a Kconfig
>entry and the base address for the debug uart.
>
>Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
>---
> arch/arm/Kconfig.debug       | 9 +++++++++
> arch/arm/include/debug/msm.S | 5 +++++
> 2 files changed, 14 insertions(+)

Acked-by: David Brown <davidb@codeaurora.org>

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
