Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab3L3VUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 16:20:05 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40816 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab3L3VUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 16:20:02 -0500
Message-ID: <52C1E380.4060307@codeaurora.org>
Date: Mon, 30 Dec 2013 13:20:00 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: arm@kernel.org
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH v2 6/7] drm/msm: Drop unnecessary mach include
References: <1388438133-431-1-git-send-email-sboyd@codeaurora.org> <1388438133-431-7-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1388438133-431-7-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/13 13:15, Stephen Boyd wrote:
> This file doesn't use the clk_reset() API that is exposed in
> mach-msm's mach/clk.h file. Remove the include so that this
> driver can be compiled as part of the multi-platform kernel.
>
> Cc: Rob Clark <robdclark@gmail.com>
> Cc: Dave Airlie <airlied@redhat.com>

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

> ---
>  drivers/gpu/drm/msm/mdp4/mdp4_dtv_encoder.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/msm/mdp4/mdp4_dtv_encoder.c b/drivers/gpu/drm/msm/mdp4/mdp4_dtv_encoder.c
> index 5e0dcae..3799ccc 100644
> --- a/drivers/gpu/drm/msm/mdp4/mdp4_dtv_encoder.c
> +++ b/drivers/gpu/drm/msm/mdp4/mdp4_dtv_encoder.c
> @@ -15,8 +15,6 @@
>   * this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
>  
> -#include <mach/clk.h>
> -
>  #include "mdp4_kms.h"
>  
>  #include "drm_crtc.h"


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

