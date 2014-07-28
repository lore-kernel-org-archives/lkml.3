Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaG1QTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:19:11 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34269 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaG1QTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:19:09 -0400
Date: Mon, 28 Jul 2014 11:19:05 -0500
From: rkuo <rkuo@codeaurora.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-hexagon <linux-hexagon@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 03/38] hexagon: drop ucontext from list exported headers
Message-ID: <20140728161905.GB9179@codeaurora.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
 <1405350546-28467-3-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405350546-28467-3-git-send-email-sam@ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 05:08:31PM +0200, Sam Ravnborg wrote:
> ucontext.h is already specified in include/uapi/asm-generic/Kbuild
> so this is redundant.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Richard Kuo <rkuo@codeaurora.org>
> Cc: linux-hexagon <linux-hexagon@vger.kernel.org>
> Cc: David Howells <dhowells@redhat.com>
> ---
>  arch/hexagon/include/asm/Kbuild | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
> index 0e69796..1ddcd97 100644
> --- a/arch/hexagon/include/asm/Kbuild
> +++ b/arch/hexagon/include/asm/Kbuild
> @@ -1,6 +1,3 @@
> -
> -header-y += ucontext.h
> -
>  generic-y += auxvec.h
>  generic-y += barrier.h
>  generic-y += bug.h
> -- 
> 1.9.3
> 


Acked-by: Richard Kuo <rkuo@codeaurora.org>

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
