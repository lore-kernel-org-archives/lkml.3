Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbbAWXWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:22:30 -0500
Received: from mail-oi0-f49.google.com ([209.85.218.49]:53451 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbAWXW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:22:26 -0500
Date: Fri, 23 Jan 2015 17:22:23 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [PATCH] PCI: xgene: Include clk.h instead of clk-private.h
Message-ID: <20150123232223.GU29776@google.com>
References: <1421954754-3217-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421954754-3217-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 11:25:54AM -0800, Stephen Boyd wrote:
> This driver should be including clk.h as it's a clock consumer,
> not a clock provider that needs to register clocks early.
> 
> Cc: Tanmay Inamdar <tinamdar@apm.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Applied provisionally to pci/host-xgene for v3.20, thanks!

I'm hoping for an ack from Tanmay.

> ---
>  drivers/pci/host/pci-xgene.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/host/pci-xgene.c b/drivers/pci/host/pci-xgene.c
> index b1d0596457c5..fdb348d3ccd3 100644
> --- a/drivers/pci/host/pci-xgene.c
> +++ b/drivers/pci/host/pci-xgene.c
> @@ -16,7 +16,7 @@
>   * GNU General Public License for more details.
>   *
>   */
> -#include <linux/clk-private.h>
> +#include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/io.h>
>  #include <linux/jiffies.h>
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
