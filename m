Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaF2Bfl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 21:35:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58267 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaF2Bfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 21:35:39 -0400
Message-ID: <53AF6D69.5060601@infradead.org>
Date: Sat, 28 Jun 2014 18:35:37 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Andi Kleen <ak@linux.intel.com>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/Changes: cleanup mcelog paragraph
References: <1403611956.1960.17.camel@x220>
In-Reply-To: <1403611956.1960.17.camel@x220>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/14 05:12, Paul Bolle wrote:
> The paragraph on mcelog currently describes kernel v2.6.31. In that
> kernel the mce code (for i386, that is) was in transition. Ever since
> v2.6.32 the situation is much simpler (eg, mcelog is now needed to
> process events on almost all x86 machines, i386 and x86-64). Since this
> "document is designed to provide a list of the minimum levels of
> software necessary to run the 3.0 kernels" let's just describe that
> situation.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  Documentation/Changes | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/Changes b/Documentation/Changes
> index 2254db0f00a5..227bec88021e 100644
> --- a/Documentation/Changes
> +++ b/Documentation/Changes
> @@ -280,12 +280,9 @@ that is possible.
>  mcelog
>  ------
>  
> -In Linux 2.6.31+ the i386 kernel needs to run the mcelog utility
> -as a regular cronjob similar to the x86-64 kernel to process and log
> -machine check events when CONFIG_X86_NEW_MCE is enabled. Machine check
> -events are errors reported by the CPU. Processing them is strongly encouraged.
> -All x86-64 kernels since 2.6.4 require the mcelog utility to
> -process machine checks.
> +On x86 kernels the mcelog utility is needed to process and log machine check
> +events when CONFIG_X86_MCE is enabled. Machine check events are errors reported
> +by the CPU. Processing them is strongly encouraged.
>  
>  Getting updated software
>  ========================
> 

Applied with Andi's ack.  Thanks.

-- 
~Randy
