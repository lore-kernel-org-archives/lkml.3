Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3JGMDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:03:16 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:41180 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab3JGMCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 08:02:49 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of/of_reserved_mem.c: fix typo
To: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
In-Reply-To: <1380705509-25429-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1380705509-25429-1-git-send-email-prabhakar.csengg@gmail.com>
Date: Fri, 04 Oct 2013 18:46:02 +0100
Message-Id: <20131004174602.1EA8FC428B6@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Oct 2013 14:48:29 +0530, Prabhakar Lad <prabhakar.csengg@gmail.com> wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Applied, thanks.
> ---
>  drivers/of/of_reserved_mem.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index 0fe40c7..c7a1ea3 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -54,7 +54,7 @@ static int __init fdt_scan_reserved_mem(unsigned long node, const char *uname,
>  
>  	status = of_get_flat_dt_prop(node, "status", &len);
>  	if (status && strcmp(status, "okay") != 0) {
> -		/* ignore disabled node nad scan next one */
> +		/* ignore disabled node and scan next one */
>  		return 0;
>  	}
>  
> -- 
> 1.7.9.5
> 

