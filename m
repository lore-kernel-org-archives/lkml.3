Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab3I3UVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:21:17 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35569 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab3I3UVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:21:15 -0400
Date: Mon, 30 Sep 2013 15:21:12 -0500
From: rkuo <rkuo@codeaurora.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-hexagon@vger.kernel.org
Subject: Re: [PATCH 07/21] hexagon: remove unnecessary prom.h includes
Message-ID: <20130930202112.GA4839@codeaurora.org>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
 <1380221456-11192-8-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380221456-11192-8-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 01:50:42PM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Hexagon does not have a prom.h header, so it is probably broken with
> CONFIG_OF enabled. In any case, remove unnecessary prom.h include in
> preparation to make prom.h optional.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Richard Kuo <rkuo@codeaurora.org>
> Cc: linux-hexagon@vger.kernel.org
> ---
>  arch/hexagon/kernel/setup.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/hexagon/kernel/setup.c b/arch/hexagon/kernel/setup.c
> index 29d1f1b..0e7c1db 100644
> --- a/arch/hexagon/kernel/setup.c
> +++ b/arch/hexagon/kernel/setup.c
> @@ -32,9 +32,6 @@
>  #include <asm/hexagon_vm.h>
>  #include <asm/vm_mmu.h>
>  #include <asm/time.h>
> -#ifdef CONFIG_OF
> -#include <asm/prom.h>
> -#endif
>  
>  char cmd_line[COMMAND_LINE_SIZE];
>  static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
> -- 
> 1.8.1.2
> 

Acked-by: Richard Kuo <rkuo@codeaurora.org>


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
