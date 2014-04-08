Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbaDHP37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:29:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757286AbaDHP34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:29:56 -0400
Message-ID: <534415F2.7020601@suse.cz>
Date: Tue, 08 Apr 2014 17:29:54 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: cocci@systeme.lip6.fr, Julia.Lawall@lip6.fr, Gilles.Muller@lip6.fr,
        nicolas.palix@imag.fr, patches@linaro.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/coccinelle: Use PTR_ERR_OR_ZERO
References: <1390805482-25075-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1390805482-25075-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-27 07:51, Sachin Kamat wrote:
> PTR_RET is deprecated. Do not recommend its usage anymore.
> Use PTR_ERR_OR_ZERO instead.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Applied to kbuild.git#misc, sorry for the delay. But please always add
lkml to the cc list.

Thanks,
Michal


> ---
>  scripts/coccinelle/api/ptr_ret.cocci |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/scripts/coccinelle/api/ptr_ret.cocci b/scripts/coccinelle/api/ptr_ret.cocci
> index e18f8402e37c..dd58dab5d411 100644
> --- a/scripts/coccinelle/api/ptr_ret.cocci
> +++ b/scripts/coccinelle/api/ptr_ret.cocci
> @@ -7,7 +7,7 @@
>  // URL: http://coccinelle.lip6.fr/
>  // Options: --no-includes --include-headers
>  //
> -// Keywords: ERR_PTR, PTR_ERR, PTR_RET, PTR_ERR_OR_ZERO
> +// Keywords: ERR_PTR, PTR_ERR, PTR_ERR_OR_ZERO
>  // Version min: 2.6.39
>  //
>  
> @@ -62,35 +62,35 @@ position p3;
>  p << r1.p1;
>  @@
>  
> -coccilib.org.print_todo(p[0], "WARNING: PTR_RET can be used")
> +coccilib.org.print_todo(p[0], "WARNING: PTR_ERR_OR_ZERO can be used")
>  
>  
>  @script:python depends on org@
>  p << r2.p2;
>  @@
>  
> -coccilib.org.print_todo(p[0], "WARNING: PTR_RET can be used")
> +coccilib.org.print_todo(p[0], "WARNING: PTR_ERR_OR_ZERO can be used")
>  
>  @script:python depends on org@
>  p << r3.p3;
>  @@
>  
> -coccilib.org.print_todo(p[0], "WARNING: PTR_RET can be used")
> +coccilib.org.print_todo(p[0], "WARNING: PTR_ERR_OR_ZERO can be used")
>  
>  @script:python depends on report@
>  p << r1.p1;
>  @@
>  
> -coccilib.report.print_report(p[0], "WARNING: PTR_RET can be used")
> +coccilib.report.print_report(p[0], "WARNING: PTR_ERR_OR_ZERO can be used")
>  
>  @script:python depends on report@
>  p << r2.p2;
>  @@
>  
> -coccilib.report.print_report(p[0], "WARNING: PTR_RET can be used")
> +coccilib.report.print_report(p[0], "WARNING: PTR_ERR_OR_ZERO can be used")
>  
>  @script:python depends on report@
>  p << r3.p3;
>  @@
>  
> -coccilib.report.print_report(p[0], "WARNING: PTR_RET can be used")
> +coccilib.report.print_report(p[0], "WARNING: PTR_ERR_OR_ZERO can be used")
> 

