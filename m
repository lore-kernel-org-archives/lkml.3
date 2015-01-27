Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbbA0H4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 02:56:45 -0500
Received: from mga03.intel.com ([134.134.136.65]:9518 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757598AbbA0H4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 02:56:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,473,1418112000"; 
   d="scan'208";a="668149810"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Kumar Amit Mehta <gmate.amit@gmail.com>, daniel.vetter@intel.com
Cc: airlied@linux.ie, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: gpu: drm: i915: intel_fifo_underrun.c: Fix a typo in comment
In-Reply-To: <1422290852-4060-1-git-send-email-gmate.amit@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1422290852-4060-1-git-send-email-gmate.amit@gmail.com>
User-Agent: Notmuch/0.19+30~g8f95761 (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 27 Jan 2015 09:56:49 +0200
Message-ID: <87siewfygu.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015, Kumar Amit Mehta <gmate.amit@gmail.com> wrote:
> The comment for intel_cpu_fifo_underrun_irq_handler() is not consistent
> with the code and the rest of the comment for this routine. This patch
> fixes this typo in comment.
>
> Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>

Reviewed-by: Jani Nikula <jani.nikula@intel.com>


> ---
>  drivers/gpu/drm/i915/intel_fifo_underrun.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_fifo_underrun.c b/drivers/gpu/drm/i915/intel_fifo_underrun.c
> index 77af512..04e248d 100644
> --- a/drivers/gpu/drm/i915/intel_fifo_underrun.c
> +++ b/drivers/gpu/drm/i915/intel_fifo_underrun.c
> @@ -341,7 +341,7 @@ bool intel_set_pch_fifo_underrun_reporting(struct drm_i915_private *dev_priv,
>  }
>  
>  /**
> - * intel_pch_fifo_underrun_irq_handler - handle PCH fifo underrun interrupt
> + * intel_cpu_fifo_underrun_irq_handler - handle CPU fifo underrun interrupt
>   * @dev_priv: i915 device instance
>   * @pipe: (CPU) pipe to set state for
>   *
> -- 
> 2.1.0
>

-- 
Jani Nikula, Intel Open Source Technology Center
