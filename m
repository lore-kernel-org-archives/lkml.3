Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab3EIKpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:45:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49063 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198Ab3EIKpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:45:53 -0400
Date: Thu, 9 May 2013 11:45:44 +0100
From: Will Deacon <will.deacon@arm.com>
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: Jonas Bonn <jonas@southpole.se>, "linux@openrisc.net" <linux@openrisc.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>,
        "ldv-project@linuxtesting.org" <ldv-project@linuxtesting.org>
Subject: Re: [PATCH 13/21] openrisc: delay: remove inline marking of
 EXPORT_SYMBOL functions
Message-ID: <20130509104543.GB11889@mudshark.cambridge.arm.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
 <1368095819-11011-2-git-send-email-yefremov.denis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368095819-11011-2-git-send-email-yefremov.denis@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 11:36:51AM +0100, Denis Efremov wrote:
> EXPORT_SYMBOL and inline directives are contradictory to each other.
> The patch fixes this inconsistency.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
> ---
>  arch/openrisc/lib/delay.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/openrisc/lib/delay.c b/arch/openrisc/lib/delay.c
> index c82b09f..808a55c 100644
> --- a/arch/openrisc/lib/delay.c
> +++ b/arch/openrisc/lib/delay.c
> @@ -37,7 +37,7 @@ void __delay(unsigned long cycles)
>  }
>  EXPORT_SYMBOL(__delay);
>  
> -inline void __const_udelay(unsigned long xloops)
> +void __const_udelay(unsigned long xloops)
>  {
>  	unsigned long long loops;

Acked-by: Will Deacon <will.deacon@arm.com>

Will
