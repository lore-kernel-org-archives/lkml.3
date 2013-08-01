Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab3HAAnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:43:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35367 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3HAAnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:43:39 -0400
Message-ID: <51F9AF1F.1060902@ti.com>
Date: Wed, 31 Jul 2013 20:43:11 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: <arm@kernel.org>, Tony Lindgren <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 10/18] ARM: OMAP2+: Switch to sched_clock_register()
References: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org> <1375309877-16617-11-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1375309877-16617-11-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 July 2013 06:31 PM, Stephen Boyd wrote:
> The 32 bit sched_clock interface now supports 64 bits. Upgrade to
> the 64 bit function to allow us to remove the 32 bit registration
> interface.
> 
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/mach-omap2/timer.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
Acked-by: Santosh Shilimkar<santosh.shilimkar@ti.com>

