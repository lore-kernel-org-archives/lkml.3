Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaE0D3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 23:29:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:25413 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751359AbaE0D3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 23:29:12 -0400
Message-ID: <1401161350.5620.0.camel@pippen.local.home>
Subject: Re: [PATCH 12/12] [include/linux] Remove strict_strto definitions
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Walter <dwalter@google.com>
Cc: linux-kernel@vger.kernel.org, richard@nod.at
Date: Mon, 26 May 2014 23:29:10 -0400
In-Reply-To: <20140526221718.GN25779@google.com>
References: <20140526221718.GN25779@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-26 at 23:17 +0100, Daniel Walter wrote:
> From: Daniel Walter <dwalter@google.com>
> Subject: [PATCH 12/12] [include/linux] remove strict_strto* definitions
> 
> Remove obsolete and unused strict_strto* functions
> 
> Signed-off-by: Daniel Walter <dwalter@google.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  include/linux/kernel.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 4c52907..a39043c 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -376,10 +376,6 @@ extern unsigned long simple_strtoul(const char *,char **,unsigned int);
>  extern long simple_strtol(const char *,char **,unsigned int);
>  extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
>  extern long long simple_strtoll(const char *,char **,unsigned int);
> -#define strict_strtoul	kstrtoul
> -#define strict_strtol	kstrtol
> -#define strict_strtoull	kstrtoull
> -#define strict_strtoll	kstrtoll
>  
>  extern int num_to_str(char *buf, int size, unsigned long long num);
>  


