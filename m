Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab3FMKbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 06:31:17 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:54124 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756394Ab3FMKbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 06:31:16 -0400
Message-ID: <1371119474.1357.6.camel@x61.thuisdomein>
Subject: Re: [PATCH] drm/omap: change "!CONFIG_FB_OMAP2" to "!FB_OMAP2"
From: Paul Bolle <pebolle@tiscali.nl>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Jun 2013 12:31:14 +0200
In-Reply-To: <1363204102.1335.6.camel@x61.thuisdomein>
References: <1363204102.1335.6.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jun 2013 10:31:14.0909 (UTC) FILETIME=[21B5B8D0:01CE6821]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-13 at 20:48 +0100, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested. Perhaps the first test that people with access to the relevant
> hardware might do, is to test _before applying this patch_ with FB_OMAP2
> set. Perhaps this negative dependency isn't needed at all. Or is it
> obvious?
> 
>  drivers/gpu/drm/omapdrm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This patch was sent exactly three months ago, shortly after v3.9-rc2 was
released. This obvious typo is still present in v3.10-rc5.

I didn't received any feedback on this patch. Did anyone had a look at
it? Is it perhaps queued somewhere?


Paul Bolle

> diff --git a/drivers/gpu/drm/omapdrm/Kconfig b/drivers/gpu/drm/omapdrm/Kconfig
> index 09f65dc..45875a0 100644
> --- a/drivers/gpu/drm/omapdrm/Kconfig
> +++ b/drivers/gpu/drm/omapdrm/Kconfig
> @@ -1,7 +1,7 @@
>  
>  config DRM_OMAP
>  	tristate "OMAP DRM"
> -	depends on DRM && !CONFIG_FB_OMAP2
> +	depends on DRM && !FB_OMAP2
>  	depends on ARCH_OMAP2PLUS || ARCH_MULTIPLATFORM
>  	depends on OMAP2_DSS
>  	select DRM_KMS_HELPER


