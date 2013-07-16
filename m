Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320Ab3GPR0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:26:09 -0400
Received: from mail-gh0-f172.google.com ([209.85.160.172]:39377 "EHLO
	mail-gh0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821Ab3GPR0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:26:07 -0400
Date: Tue, 16 Jul 2013 14:19:40 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] perf completion: modernize style
Message-ID: <20130716171940.GA2559@ghostprotocols.net>
References: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
 <1372941691-14684-5-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372941691-14684-5-git-send-email-artagnon@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 04, 2013 at 06:11:28PM +0530, Ramkumar Ramachandra escreveu:
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  tools/perf/bash_completion | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
> index d2598be..8c04f5d 100644
> --- a/tools/perf/bash_completion
> +++ b/tools/perf/bash_completion
> @@ -7,7 +7,7 @@ function_exists()
>  }
>  
>  function_exists __ltrim_colon_completions ||
> -__ltrim_colon_completions()
> +__ltrim_colon_completions ()

Huh? Why would this be more "modern", if both are equivalent, I think
applying the same rules as we have for C code applies here.

- Arnaldo

>  {
>  	if [[ "$1" == *:* && "$COMP_WORDBREAKS" == *:* ]]; then
>  		# Remove colon-word prefix from COMPREPLY items
> @@ -20,7 +20,7 @@ __ltrim_colon_completions()
>  }
>  
>  type perf &>/dev/null &&
> -_perf()
> +_perf ()
>  {
>  	local cur prev cmd
>  
> -- 
> 1.8.3.1.643.gebeea52.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
