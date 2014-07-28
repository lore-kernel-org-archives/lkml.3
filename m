Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaG1QTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:19:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34300 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaG1QT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:19:29 -0400
Date: Mon, 28 Jul 2014 11:19:26 -0500
From: rkuo <rkuo@codeaurora.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 19/38] hexagon: clean-up uapi Kbuild file
Message-ID: <20140728161926.GC9179@codeaurora.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
 <1405350546-28467-19-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405350546-28467-19-git-send-email-sam@ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 05:08:47PM +0200, Sam Ravnborg wrote:
> Remove redundant assignments.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Richard Kuo <rkuo@codeaurora.org>
> ---
>  arch/hexagon/include/uapi/asm/Kbuild | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/arch/hexagon/include/uapi/asm/Kbuild b/arch/hexagon/include/uapi/asm/Kbuild
> index c31706c..3f464d5 100644
> --- a/arch/hexagon/include/uapi/asm/Kbuild
> +++ b/arch/hexagon/include/uapi/asm/Kbuild
> @@ -1,15 +1,5 @@
>  # UAPI Header export list
>  include include/uapi/asm-generic/Kbuild.asm
>  
> -header-y += bitsperlong.h
> -header-y += byteorder.h
> -header-y += kvm_para.h
> -header-y += param.h
> -header-y += ptrace.h
>  header-y += registers.h
> -header-y += setup.h
> -header-y += sigcontext.h
> -header-y += signal.h
> -header-y += swab.h
> -header-y += unistd.h
>  header-y += user.h
> -- 
> 1.9.3
> 

Acked-by: Richard Kuo <rkuo@codeaurora.org>

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
