Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaJXTKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:10:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:57944 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbaJXTKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:10:30 -0400
Message-ID: <544AA421.6040705@infradead.org>
Date: Fri, 24 Oct 2014 12:10:25 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, catalin.marinas@arm.com,
        corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Documentation: Add CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
 case
References: <1414153500-29150-1-git-send-email-standby24x7@gmail.com> <1414153500-29150-3-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1414153500-29150-3-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/14 05:25, Masanari Iida wrote:
> This patch add a case with CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  Documentation/kmemleak.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
> index f4f033c..0f2bbd8 100644
> --- a/Documentation/kmemleak.txt
> +++ b/Documentation/kmemleak.txt
> @@ -62,6 +62,10 @@ Memory may be allocated or freed before kmemleak is initialised and
>  these actions are stored in an early log buffer. The size of this buffer
>  is configured via the CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE option.
>  
> +If CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF are enabled, the kmemleak is

                                        is enabled, kmemleak is

> +disabled by default. Passing "kmemleak=on" on the kernel command
> +line enables the function. 
> +
>  Basic Algorithm
>  ---------------
>  
> 


-- 
~Randy
