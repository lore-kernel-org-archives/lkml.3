Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab3LFSX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:23:26 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56751 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3LFSXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:23:23 -0500
Date: Fri, 6 Dec 2013 12:23:20 -0600
From: rkuo <rkuo@codeaurora.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: hexagon: kernel: reset.c: use function pointer
 instead of function for pm_power_off and export it
Message-ID: <20131206182320.GE11490@codeaurora.org>
References: <529811A1.3030708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529811A1.3030708@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 12:01:37PM +0800, Chen Gang wrote:
> 'pm_power_off' is a function pointer, not a function, so need change
> its type, and also need export it, or can not pass compiling with
> allmodconfig. The related error:
> 
>     MODPOST 2879 modules
>   ERROR: "pm_power_off" [drivers/char/ipmi/ipmi_poweroff.ko] undefined!
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/hexagon/kernel/reset.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 

Acked-by: Richard Kuo <rkuo@codeaurora.org>

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
