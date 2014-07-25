Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761013AbaGYTvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:51:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:49043 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbaGYTvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:51:12 -0400
Message-ID: <53D2B52B.6050402@infradead.org>
Date: Fri, 25 Jul 2014 12:51:07 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Raymond L. Rivera" <ray.l.rivera@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH 1/2] CodingStyle: Fixed a minor typo.
References: <1406194785-19596-1-git-send-email-ray.l.rivera@gmail.com> <1406194785-19596-2-git-send-email-ray.l.rivera@gmail.com>
In-Reply-To: <1406194785-19596-2-git-send-email-ray.l.rivera@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/14 02:39, Raymond L. Rivera wrote:
> There was a minor typo in the CodingStyle document where the word 'section'
> had been spelled as 'secton'.
> 
> Signed-off-by: Raymond L. Rivera <ray.l.rivera@gmail.com>

Jiri, please pick up patches 1 & 2 for trivial.
Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  Documentation/CodingStyle | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index 6b6bef3..3171822 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -675,7 +675,7 @@ the ones already enabled by DEBUG.
>  Many subsystems have Kconfig debug options to turn on -DDEBUG in the
>  corresponding Makefile; in other cases specific files #define DEBUG.  And
>  when a debug message should be unconditionally printed, such as if it is
> -already inside a debug-related #ifdef secton, printk(KERN_DEBUG ...) can be
> +already inside a debug-related #ifdef section, printk(KERN_DEBUG ...) can be
>  used.
>  
>  
> 


-- 
~Randy
