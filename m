Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbaKDQac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:30:32 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59364 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaKDQa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:30:29 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: Fix padding in _OF_DECLARE macro definition
To: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1412258470-23940-1-git-send-email-thierry.reding@gmail.com>
References: <1412258470-23940-1-git-send-email-thierry.reding@gmail.com>
Date: Tue, 04 Nov 2014 16:30:21 +0000
Message-Id: <20141104163021.21F9AC423D0@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Oct 2014 16:01:10 +0200
, Thierry Reding <thierry.reding@gmail.com>
 wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Applied, thanks.

g.

> ---
>  include/linux/of.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 6c4363b8ddc3..951e9ee7d3e0 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -772,7 +772,7 @@ static inline int of_get_available_child_count(const struct device_node *np)
>  		 = { .compatible = compat,				\
>  		     .data = (fn == (fn_type)NULL) ? fn : fn  }
>  #else
> -#define _OF_DECLARE(table, name, compat, fn, fn_type)					\
> +#define _OF_DECLARE(table, name, compat, fn, fn_type)			\
>  	static const struct of_device_id __of_table_##name		\
>  		__attribute__((unused))					\
>  		 = { .compatible = compat,				\
> -- 
> 2.1.0
> 

