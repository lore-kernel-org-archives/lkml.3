Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab3KMTXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 14:23:15 -0500
Received: from mga03.intel.com ([143.182.124.21]:27352 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab3KMTXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 14:23:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,693,1378882800"; 
   d="scan'208";a="427099239"
Date: Wed, 13 Nov 2013 21:22:59 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [Intel-gfx] [PATCH] x86/early quirk: use gen6 stolen detection
 for VLV
Message-ID: <20131113192259.GI7819@intel.com>
References: <1384280259-800-1-git-send-email-jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384280259-800-1-git-send-email-jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 10:17:39AM -0800, Jesse Barnes wrote:
> We've always been able to use either method on VLV, but it appears more
> recent BIOSes only support the gen6 method, so switch over to that.

I'm not sure what tha means since we've been using the gen6 method for
a long time now (except for the early quirk).

But anyways this matches the specs so:
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

> 
> References: https://bugs.freedesktop.org/show_bug.cgi?id=71370
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  arch/x86/kernel/early-quirks.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index 96f958d..bc4a088 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -330,8 +330,8 @@ static struct pci_device_id intel_stolen_ids[] __initdata = {
>  	INTEL_I915GM_IDS(gen3_stolen_size),
>  	INTEL_I945G_IDS(gen3_stolen_size),
>  	INTEL_I945GM_IDS(gen3_stolen_size),
> -	INTEL_VLV_M_IDS(gen3_stolen_size),
> -	INTEL_VLV_D_IDS(gen3_stolen_size),
> +	INTEL_VLV_M_IDS(gen6_stolen_size),
> +	INTEL_VLV_D_IDS(gen6_stolen_size),
>  	INTEL_PINEVIEW_IDS(gen3_stolen_size),
>  	INTEL_I965G_IDS(gen3_stolen_size),
>  	INTEL_G33_IDS(gen3_stolen_size),
> -- 
> 1.8.4.2
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Ville Syrjälä
Intel OTC
