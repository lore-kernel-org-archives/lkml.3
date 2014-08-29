Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaH2HLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 03:11:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13504 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaH2HLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:11:51 -0400
X-AuditID: cbfee691-f79546d0000011a1-4b-540027b474a5
Message-id: <540027B5.5070704@samsung.com>
Date: Fri, 29 Aug 2014 16:11:49 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>, Inki Dae <inki.dae@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH v2 17/17] drm/exynos/ipp: add file checks for ioctls
References: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
 <1409216861-12452-18-git-send-email-a.hajda@samsung.com>
In-reply-to: <1409216861-12452-18-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsWyRsSkUHeLOkOIwdUrFha31p1jtbjy9T2b
	xaT7E1gsXty7yGJxtukNu8XlXXPYLGac38dksfbIXXaLGZNfsjlwetzvPs7k0bdlFaPH501y
	AcxRXDYpqTmZZalF+nYJXBnPZy9gL7gjXPHhxGTWBsZ5Al2MnBwSAiYSyzf8ZYawxSQu3FvP
	1sXIxSEksJRRomX2I6AEB1jRjg8GEPHpjBL7r5xgB2kQEnjFKNHwRBSkhldAS+L7H1GQMIuA
	qsTcu71gJWwCehJ3th1nArFFBUIk3hxvB4vzCghK/Jh8jwXEFhHwkJj/Zg/YDcwCZ5gkvq7X
	BbGFgeKLTz1hgVhVJ3HxUTeYzSngKnFt0jk2kLXMQPPvX9SCaJWX2LzmLTPImRIC59glZp7u
	YoG4R0Di2+RDLBCvyEpsOgD1rqTEwRU3WCYwis1CctEshKmzkExdwMi8ilE0tSC5oDgpvchU
	rzgxt7g0L10vOT93EyMw3k7/ezZxB+P9A9aHGAU4GJV4eDtO/g8WYk0sK67MPcRoCnTERGYp
	0eR8YFTnlcQbGpsZWZiamBobmVuaKYnz6kj/DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	WMaueVPn+0HfAC5uNiXThjcJVhGf1n7b/jZztmDZ+a+NPCe/T2UK3SRwYNpWnzNTxfddWLWe
	Vbsv/62DT9f+Su24U/uEu+SVVSxiYubOmT/h4c2K/lQN6daLVz2Lg034FW/4i6+Q7vF9kH/E
	zJSz+KwBQwpr14Xyx0zTnP836V826j3mf0NFiaU4I9FQi7moOBEAu6J807ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t9jQd0t6gwhBo3nDS1urTvHanHl63s2
	i0n3J7BYvLh3kcXibNMbdovLu+awWcw4v4/JYu2Ru+wWMya/ZHPg9LjffZzJo2/LKkaPz5vk
	ApijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4Du
	UFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmPJ+9gL3gjnDFhxOTWRsY
	5wl0MXJwSAiYSOz4YNDFyAlkiklcuLeerYuRi0NIYDqjxP4rJ9hBEkICrxglGp6IgtTzCmhJ
	fP8jChJmEVCVmHu3F6yETUBP4s6240wgtqhAiMSb4+1gcV4BQYkfk++xgNgiAh4S89/sYQax
	mQXOMEl8Xa8LYgsDxRefesICsapO4uKjbjCbU8BV4tqkc2wga5mB5t+/qAXRKi+xec1b5gmM
	ArOQbJiFUDULSdUCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHR/Ex6B+OqBotDjAIc
	jEo8vB0n/wcLsSaWFVfmHmKU4GBWEuEtfAYU4k1JrKxKLcqPLyrNSS0+xGgK9P9EZinR5Hxg
	oskriTc0NjEzsjQyN7QwMjZXEuc92GodKCSQnliSmp2aWpBaBNPHxMEp1cCoYvlowvKiT9te
	rBIIVBbjfCq0tlFWXWiJzgJbNee8vdv3BB7R76m812MUcG/RT5vbIlZy7RbzTzNH3NvE8PbP
	yhu7n7DGs7050xbw9+6jd3O7bir9DXoSmiLeoSww42+jX7JL2nm5zjrTNev0JcU7Gx+db9LZ
	mh3z52Nh9YM/Da9ELZwfKJcqsRRnJBpqMRcVJwIAxJbnFvwCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrzej,

On 08/28/2014 06:07 PM, Andrzej Hajda wrote:
> Process should not have access to ipp nodes created by another
> process. The patch adds necessary checks.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_ipp.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
> index fc8bb67..d233cfc 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
> @@ -318,7 +318,8 @@ static void ipp_print_property(struct drm_exynos_ipp_property *property,
>  		sz->hsize, sz->vsize, config->flip, config->degree);
>  }
>  
> -static int ipp_find_and_set_property(struct drm_exynos_ipp_property *property)
> +static int ipp_find_and_set_property(struct drm_exynos_ipp_property *property,
> +		struct drm_file *file)

This is ok, but i think ipp_find_and_set_property function is some
duplicated. If we add function to get c_node from struct
exynos_drm_ippdrv, it's easy to remove ipp_find_and_set_property.

Thanks.

>  {
>  	struct exynos_drm_ippdrv *ippdrv;
>  	struct drm_exynos_ipp_cmd_node *c_node;
> @@ -339,8 +340,12 @@ static int ipp_find_and_set_property(struct drm_exynos_ipp_property *property)
>  	 */
>  	mutex_lock(&ippdrv->cmd_lock);
>  	list_for_each_entry(c_node, &ippdrv->cmd_list, list) {
> -		if ((c_node->property.prop_id == prop_id) &&
> -		    (c_node->state == IPP_STATE_STOP)) {
> +		if (c_node->property.prop_id == prop_id) {
> +			if (c_node->filp != file)
> +				break;
> +			if (c_node->state != IPP_STATE_STOP)
> +				break;
> +
>  			mutex_unlock(&ippdrv->cmd_lock);
>  			DRM_DEBUG_KMS("found cmd[%d]ippdrv[0x%x]\n",
>  				property->cmd, (int)ippdrv);
> @@ -418,7 +423,7 @@ int exynos_drm_ipp_set_property(struct drm_device *drm_dev, void *data,
>  	 */
>  	if (property->prop_id) {
>  		DRM_DEBUG_KMS("prop_id[%d]\n", property->prop_id);
> -		return ipp_find_and_set_property(property);
> +		return ipp_find_and_set_property(property, file);
>  	}
>  
>  	/* find ipp driver using ipp id */
> @@ -1032,7 +1037,7 @@ int exynos_drm_ipp_cmd_ctrl(struct drm_device *drm_dev, void *data,
>  
>  	c_node = ipp_find_obj(&ctx->prop_idr, &ctx->prop_lock,
>  		cmd_ctrl->prop_id);
> -	if (!c_node) {
> +	if (!c_node || c_node->filp != file) {
>  		DRM_ERROR("invalid command node list.\n");
>  		return -ENODEV;
>  	}
> 

