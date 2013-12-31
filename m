Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab3LaBMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 20:12:35 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:62035 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365Ab3LaBMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 20:12:33 -0500
MIME-Version: 1.0
In-Reply-To: <1388438133-431-7-git-send-email-sboyd@codeaurora.org>
References: <1388438133-431-1-git-send-email-sboyd@codeaurora.org>
	<1388438133-431-7-git-send-email-sboyd@codeaurora.org>
Date: Mon, 30 Dec 2013 20:12:33 -0500
Message-ID: <CAF6AEGtortD9FQP-vDj7apsmdkXcoOiahJf++zPcSh=OYg7WfA@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] drm/msm: Drop unnecessary mach include
From: Rob Clark <robdclark@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: arm@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Dave Airlie <airlied@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 4:15 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> This file doesn't use the clk_reset() API that is exposed in
> mach-msm's mach/clk.h file. Remove the include so that this
> driver can be compiled as part of the multi-platform kernel.

Thanks!

Signed-off-by: Rob Clark <robdclark@gmail.com>


> Cc: Rob Clark <robdclark@gmail.com>
> Cc: Dave Airlie <airlied@redhat.com>
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
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>
