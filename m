Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3EIKla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:41:30 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:56847 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753719Ab3EIKl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:41:28 -0400
Date: Thu, 9 May 2013 11:39:40 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>,
        "ldv-project@linuxtesting.org" <ldv-project@linuxtesting.org>
Subject: Re: [PATCH 14/21] arm64: delay: remove inline marking of
 EXPORT_SYMBOL functions
Message-ID: <20130509103939.GD668@arm.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
 <1368095819-11011-3-git-send-email-yefremov.denis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368095819-11011-3-git-send-email-yefremov.denis@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 11:36:52AM +0100, Denis Efremov wrote:
> EXPORT_SYMBOL and inline directives are contradictory to each other.
> The patch fixes this inconsistency.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
> ---
>  arch/arm64/lib/delay.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/lib/delay.c b/arch/arm64/lib/delay.c
> index dad4ec9..368ca15 100644
> --- a/arch/arm64/lib/delay.c
> +++ b/arch/arm64/lib/delay.c
> @@ -33,7 +33,7 @@ void __delay(unsigned long cycles)
>  }
>  EXPORT_SYMBOL(__delay);
>  
> -inline void __const_udelay(unsigned long xloops)
> +void __const_udelay(unsigned long xloops)
>  {
>  	unsigned long loops;

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
