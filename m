Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaHTGay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:30:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:43561 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaHTGaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:30:52 -0400
Message-ID: <53F44098.2050209@infradead.org>
Date: Tue, 19 Aug 2014 23:30:48 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: harish_kandiga@mentor.com
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] lockup-watchdogs: Fix a typo
References: <1408515977-13263-1-git-send-email-harish_kandiga@mentor.com>
In-Reply-To: <1408515977-13263-1-git-send-email-harish_kandiga@mentor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/14 23:26, harish_kandiga@mentor.com wrote:
> From: Harish Jenny K N <harish_kandiga@mentor.com>
> 
> s/BOOTPARAM_HARDLOCKUP_PANIC/BOOTPARAM_SOFTLOCKUP_PANIC
> 
> Signed-off-by: Harish Jenny K N <harish_kandiga@mentor.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Jiri, please add to the trivial tree.

Thanks.

> ---
>  Documentation/lockup-watchdogs.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/lockup-watchdogs.txt b/Documentation/lockup-watchdogs.txt
> index d2a3660..ab0baa6 100644
> --- a/Documentation/lockup-watchdogs.txt
> +++ b/Documentation/lockup-watchdogs.txt
> @@ -12,7 +12,7 @@ stack trace is displayed upon detection and, by default, the system
>  will stay locked up. Alternatively, the kernel can be configured to
>  panic; a sysctl, "kernel.softlockup_panic", a kernel parameter,
>  "softlockup_panic" (see "Documentation/kernel-parameters.txt" for
> -details), and a compile option, "BOOTPARAM_HARDLOCKUP_PANIC", are
> +details), and a compile option, "BOOTPARAM_SOFTLOCKUP_PANIC", are
>  provided for this.
>  
>  A 'hardlockup' is defined as a bug that causes the CPU to loop in
> 


-- 
~Randy
