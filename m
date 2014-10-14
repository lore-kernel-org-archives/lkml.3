Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbaJNJ0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 05:26:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41098 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137AbaJNJ0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 05:26:23 -0400
Date: Tue, 14 Oct 2014 10:25:52 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v2 1/1] Documentation: dt-bindings: Explain order in
 patch series
Message-ID: <20141014092552.GG16598@leverpostej>
References: <1412879047-24138-1-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412879047-24138-1-git-send-email-javier.martinez@collabora.co.uk>
Thread-Topic: [PATCH v2 1/1] Documentation: dt-bindings: Explain order in
 patch series
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 07:24:07PM +0100, Javier Martinez Canillas wrote:
> When posting a patch series that includes both code implementing a
> Device Tree binding and its associated documentation, the DT docs
> should come in the series before the implementation.
> 
> This not only avoids checkpatch.pl to complain about undocumented
> bindings but also makes the review process easier.
> 
> Document this convention since it may not be obvious.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Following the discussion around [1], this makes sense to me, so:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

[1] http://lkml.kernel.org/r/54356666.4090003@collabora.co.uk

> ---
> 
> Changes since v1:
>  - Small typo error, sorry for the noise.
> 
>  Documentation/devicetree/bindings/submitting-patches.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/submitting-patches.txt b/Documentation/devicetree/bindings/submitting-patches.txt
> index 042a027..b7ba01a 100644
> --- a/Documentation/devicetree/bindings/submitting-patches.txt
> +++ b/Documentation/devicetree/bindings/submitting-patches.txt
> @@ -12,6 +12,9 @@ I. For patch submitters
>  
>         devicetree@vger.kernel.org
>  
> +  3) The Documentation/ portion of the patch should come in the series before
> +     the code implementing the binding.
> +
>  II. For kernel maintainers
>  
>    1) If you aren't comfortable reviewing a given binding, reply to it and ask
> -- 
> 2.1.0
> 
> 
