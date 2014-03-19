Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934297AbaCSRCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:02:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58708 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574AbaCSRCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:02:35 -0400
Message-ID: <5329CDA9.7000707@codeaurora.org>
Date: Wed, 19 Mar 2014 13:02:33 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>
CC: Christopher Covington <cov@codeaurora.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Remove extraneous kcmp syscall ignore
References: <1392403099-13411-1-git-send-email-cov@codeaurora.org>
In-Reply-To: <1392403099-13411-1-git-send-email-cov@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 01:38 PM, Christopher Covington wrote:
> The kcmp system call was ported to ARM in
> commit 3f7d1fe108dbaefd0c57a41753fc2c90b395f458
> "ARM: 7665/1: Wire up kcmp syscall".
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> ---
>  arch/arm/include/asm/unistd.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
> index 141baa3..cbd6197 100644
> --- a/arch/arm/include/asm/unistd.h
> +++ b/arch/arm/include/asm/unistd.h
> @@ -48,6 +48,5 @@
>   */
>  #define __IGNORE_fadvise64_64
>  #define __IGNORE_migrate_pages
> -#define __IGNORE_kcmp
>  
>  #endif /* __ASM_ARM_UNISTD_H */

Seeing no objections, will add to the patch tracker.

Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
