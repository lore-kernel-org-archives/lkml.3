Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaISBCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 21:02:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39060 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaISBCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 21:02:14 -0400
X-AuditID: cbfee68f-f797f6d000001173-e0-541b8093e7a0
Message-id: <541B8093.6040807@samsung.com>
Date: Fri, 19 Sep 2014 10:02:11 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101
 Thunderbird/31.1.1
MIME-version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>, Inki Dae <inki.dae@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        "open list:DRM DRIVERS FOR E..." <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, drake@endlessm.com,
        daniel@ffwll.ch, m.szyprowski@samsung.com
Subject: Re: [PATCH] drm/exynos: switch to universal plane API
References: <1411046223-22703-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1411046223-22703-1-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWyRsSkWHdyg3SIQXuPqcWtdedYLXrPnWSy
	+L9tIrPFo/mPmS2ufH3PZjHp/gQWi94FV9kszja9Ybe4vGsOm8WM8/uYLNYeuctuMWPySzYH
	Ho9F37M89n5bwOKx/dsDVo/73ceZPPq2rGL0+LxJLoAtissmJTUnsyy1SN8ugSvjxukljAXn
	/SqmfVjB2MC4376LkZNDQsBEYu7vJcwQtpjEhXvr2boYuTiEBJYySmyZNIMZpqh/0xMWiMR0
	Rolv0zcwQTivGSXm/PoIVsUroCXx8fl8FhCbRUBVonnfSTCbTUBP4s6240ANHByiAmESf29z
	Q5QLSvyYfA+sRETAQ2L+mz3MIDOZBeYxS6xp/w6WEBawk/g18yYjiC0k4CyxasJ6JhCbU8BF
	YsKt2cwgM5mB5t+/qAUSZhaQl9i85i3YHAmBv+wSE2e8hbpHQOLb5EMsIPUSArISmw5APSYp
	cXDFDZYJjGKzkJw0C2HqLCRTFzAyr2IUTS1ILihOSi8y1itOzC0uzUvXS87P3cQIjNfT/571
	72C8e8D6EKMAB6MSD69nmnSIEGtiWXFl7iFGU6AjJjJLiSbnA5NCXkm8obGZkYWpiamxkbml
	mZI470Kpn8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGM1s/O/PnMfzxuPr0TnFzVyPr/gZ
	bXwwI8Xz6OqdV1iXPNrLFaIt6dN6dMcSxZqI2vdz32t9Xn34ypdqKf3vpnInNgXzHpSanPL9
	0zQOs86PmxJniz3d36Yw4fVcfc9NBxZwdNj81ed7EV+36RnHpnPfihuWbOLWbFjbNp/fxyB8
	p1iJQ4FK9AclluKMREMt5qLiRABwmFQ70gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xoO7kBukQg/eHtCxurTvHatF77iST
	xf9tE5ktHs1/zGxx5et7NotJ9yewWPQuuMpmcbbpDbvF5V1z2CxmnN/HZLH2yF12ixmTX7I5
	8Hgs+p7lsffbAhaP7d8esHrc7z7O5NG3ZRWjx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl56bZK
	3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlARyoplCXmlAKFAhKLi5X07TBNCA1x07WA
	aYzQ9Q0JgusxMkADCWsYM26cXsJYcN6vYtqHFYwNjPvtuxg5OSQETCT6Nz1hgbDFJC7cW8/W
	xcjFISQwnVHi2/QNTBDOa0aJOb8+MoNU8QpoSXx8Ph+sg0VAVaJ530kwm01AT+LOtuNADRwc
	ogJhEn9vc0OUC0r8mHwPrEREwENi/ps9zCAzmQXmMUusaf8OlhAWsJP4NfMmI4gtJOAssWrC
	eiYQm1PARWLCrdnMIDOZgebfv6gFEmYWkJfYvOYt8wRGgVlIVsxCqJqFpGoBI/MqRtHUguSC
	4qT0XEO94sTc4tK8dL3k/NxNjOBk8ExqB+PKBotDjAIcjEo8vB5p0iFCrIllxZW5hxglOJiV
	RHiFPYBCvCmJlVWpRfnxRaU5qcWHGE2B/p/ILCWanA9MVHkl8YbGJmZGlkbmhhZGxuZK4rwH
	Wq0DhQTSE0tSs1NTC1KLYPqYODilGhhL91YsNLO680duW8jqb4rmS684W0pNZY6+U3hKZ/Gk
	wxc6l7WzcprZFCguvMT9vVZFQfrPGv6OT0Wy3Afsfh2vNXzw3fn4IY9L3Z+0Q38K3uycK58W
	2yzAI7zA0Yj375vUe4U6P2Z+uP7Xl3Wetf2BSP9k/ozTbyduePNwY4iTuKCo/+1p6cJKLMUZ
	iYZazEXFiQD90stkHAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrzej,

On 09/18/2014 10:17 PM, Andrzej Hajda wrote:
> The patch replaces legacy functions
> drm_plane_init() / drm_crtc_init() with
> drm_universal_plane_init() and drm_crtc_init_with_planes().
> It allows to replace fake primary plane with the real one.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
> Hi Inki,
> 
> I have tested this patch with trats board, it looks OK.
> As a side effect it should solve fb refcounting issues
> reported by me and Daniel Drake.
> 
> Regards
> Andrzej
> ---
>  drivers/gpu/drm/exynos/exynos_drm_crtc.c  | 63 ++++++++++++++++---------------
>  drivers/gpu/drm/exynos/exynos_drm_drv.c   |  5 ++-
>  drivers/gpu/drm/exynos/exynos_drm_plane.c | 17 +++++----
>  drivers/gpu/drm/exynos/exynos_drm_plane.h |  3 +-
>  4 files changed, 47 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
> index b68e58f..d2f713e 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
> @@ -32,7 +32,6 @@ enum exynos_crtc_mode {
>   * Exynos specific crtc structure.
>   *
>   * @drm_crtc: crtc object.
> - * @drm_plane: pointer of private plane object for this crtc
>   * @manager: the manager associated with this crtc
>   * @pipe: a crtc index created at load() with a new crtc object creation
>   *	and the crtc object would be set to private->crtc array
> @@ -46,7 +45,6 @@ enum exynos_crtc_mode {
>   */
>  struct exynos_drm_crtc {
>  	struct drm_crtc			drm_crtc;
> -	struct drm_plane		*plane;
>  	struct exynos_drm_manager	*manager;
>  	unsigned int			pipe;
>  	unsigned int			dpms;
> @@ -94,12 +92,12 @@ static void exynos_drm_crtc_commit(struct drm_crtc *crtc)
>  
>  	exynos_drm_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
>  
> -	exynos_plane_commit(exynos_crtc->plane);
> +	exynos_plane_commit(crtc->primary);
>  
>  	if (manager->ops->commit)
>  		manager->ops->commit(manager);
>  
> -	exynos_plane_dpms(exynos_crtc->plane, DRM_MODE_DPMS_ON);
> +	exynos_plane_dpms(crtc->primary, DRM_MODE_DPMS_ON);
>  }
>  
>  static bool
> @@ -123,10 +121,9 @@ exynos_drm_crtc_mode_set(struct drm_crtc *crtc, struct drm_display_mode *mode,
>  {
>  	struct exynos_drm_crtc *exynos_crtc = to_exynos_crtc(crtc);
>  	struct exynos_drm_manager *manager = exynos_crtc->manager;
> -	struct drm_plane *plane = exynos_crtc->plane;
> +	struct drm_framebuffer *fb = crtc->primary->fb;
>  	unsigned int crtc_w;
>  	unsigned int crtc_h;
> -	int ret;
>  
>  	/*
>  	 * copy the mode data adjusted by mode_fixup() into crtc->mode
> @@ -134,29 +131,21 @@ exynos_drm_crtc_mode_set(struct drm_crtc *crtc, struct drm_display_mode *mode,
>  	 */
>  	memcpy(&crtc->mode, adjusted_mode, sizeof(*adjusted_mode));
>  
> -	crtc_w = crtc->primary->fb->width - x;
> -	crtc_h = crtc->primary->fb->height - y;
> +	crtc_w = fb->width - x;
> +	crtc_h = fb->height - y;
>  
>  	if (manager->ops->mode_set)
>  		manager->ops->mode_set(manager, &crtc->mode);
>  
> -	ret = exynos_plane_mode_set(plane, crtc, crtc->primary->fb, 0, 0, crtc_w, crtc_h,
> -				    x, y, crtc_w, crtc_h);
> -	if (ret)
> -		return ret;
> -
> -	plane->crtc = crtc;
> -	plane->fb = crtc->primary->fb;
> -	drm_framebuffer_reference(plane->fb);
> -
> -	return 0;
> +	return exynos_plane_mode_set(crtc->primary, crtc, fb, 0, 0,
> +				     crtc_w, crtc_h, x, y, crtc_w, crtc_h);
>  }
>  
>  static int exynos_drm_crtc_mode_set_commit(struct drm_crtc *crtc, int x, int y,
>  					  struct drm_framebuffer *old_fb)
>  {
>  	struct exynos_drm_crtc *exynos_crtc = to_exynos_crtc(crtc);
> -	struct drm_plane *plane = exynos_crtc->plane;
> +	struct drm_framebuffer *fb = crtc->primary->fb;
>  	unsigned int crtc_w;
>  	unsigned int crtc_h;
>  	int ret;
> @@ -167,11 +156,11 @@ static int exynos_drm_crtc_mode_set_commit(struct drm_crtc *crtc, int x, int y,
>  		return -EPERM;
>  	}
>  
> -	crtc_w = crtc->primary->fb->width - x;
> -	crtc_h = crtc->primary->fb->height - y;
> +	crtc_w = fb->width - x;
> +	crtc_h = fb->height - y;
>  
> -	ret = exynos_plane_mode_set(plane, crtc, crtc->primary->fb, 0, 0, crtc_w, crtc_h,
> -				    x, y, crtc_w, crtc_h);
> +	ret = exynos_plane_mode_set(crtc->primary, crtc, fb, 0, 0,
> +				    crtc_w, crtc_h, x, y, crtc_w, crtc_h);
>  	if (ret)
>  		return ret;
>  
> @@ -279,6 +268,7 @@ static void exynos_drm_crtc_destroy(struct drm_crtc *crtc)
>  
>  	private->crtc[exynos_crtc->pipe] = NULL;
>  
> +	crtc->primary->funcs->destroy(crtc->primary);

This is unnecessary.

>  	drm_crtc_cleanup(crtc);
>  	kfree(exynos_crtc);
>  }
> @@ -304,8 +294,7 @@ static int exynos_drm_crtc_set_property(struct drm_crtc *crtc,
>  			exynos_drm_crtc_commit(crtc);
>  			break;
>  		case CRTC_MODE_BLANK:
> -			exynos_plane_dpms(exynos_crtc->plane,
> -					  DRM_MODE_DPMS_OFF);
> +			exynos_plane_dpms(crtc->primary, DRM_MODE_DPMS_OFF);
>  			break;
>  		default:
>  			break;
> @@ -351,8 +340,10 @@ static void exynos_drm_crtc_attach_mode_property(struct drm_crtc *crtc)
>  int exynos_drm_crtc_create(struct exynos_drm_manager *manager)
>  {
>  	struct exynos_drm_crtc *exynos_crtc;
> +	struct drm_plane *plane;
>  	struct exynos_drm_private *private = manager->drm_dev->dev_private;
>  	struct drm_crtc *crtc;
> +	int ret;
>  
>  	exynos_crtc = kzalloc(sizeof(*exynos_crtc), GFP_KERNEL);
>  	if (!exynos_crtc)
> @@ -364,11 +355,11 @@ int exynos_drm_crtc_create(struct exynos_drm_manager *manager)
>  	exynos_crtc->dpms = DRM_MODE_DPMS_OFF;
>  	exynos_crtc->manager = manager;
>  	exynos_crtc->pipe = manager->pipe;
> -	exynos_crtc->plane = exynos_plane_init(manager->drm_dev,
> -				1 << manager->pipe, true);
> -	if (!exynos_crtc->plane) {
> -		kfree(exynos_crtc);
> -		return -ENOMEM;
> +	plane = exynos_plane_init(manager->drm_dev, 1 << manager->pipe,
> +				  DRM_PLANE_TYPE_PRIMARY);
> +	if (IS_ERR(plane)) {
> +		ret = PTR_ERR(plane);
> +		goto err_plane;
>  	}
>  
>  	manager->crtc = &exynos_crtc->drm_crtc;
> @@ -376,12 +367,22 @@ int exynos_drm_crtc_create(struct exynos_drm_manager *manager)
>  
>  	private->crtc[manager->pipe] = crtc;
>  
> -	drm_crtc_init(manager->drm_dev, crtc, &exynos_crtc_funcs);
> +	ret = drm_crtc_init_with_planes(manager->drm_dev, crtc, plane, NULL,
> +					&exynos_crtc_funcs);
> +	if (ret < 0)
> +		goto err_crtc;
> +
>  	drm_crtc_helper_add(crtc, &exynos_crtc_helper_funcs);
>  
>  	exynos_drm_crtc_attach_mode_property(crtc);
>  
>  	return 0;
> +
> +err_crtc:
> +	plane->funcs->destroy(plane);
> +err_plane:
> +	kfree(exynos_crtc);
> +	return ret;
>  }
>  
>  int exynos_drm_crtc_enable_vblank(struct drm_device *dev, int pipe)
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> index 9b00e4e..a439452 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> @@ -86,8 +86,9 @@ static int exynos_drm_load(struct drm_device *dev, unsigned long flags)
>  		struct drm_plane *plane;
>  		unsigned long possible_crtcs = (1 << MAX_CRTC) - 1;
>  
> -		plane = exynos_plane_init(dev, possible_crtcs, false);
> -		if (!plane)
> +		plane = exynos_plane_init(dev, possible_crtcs,
> +					  DRM_PLANE_TYPE_OVERLAY);
> +		if (IS_ERR(plane))
>  			goto err_mode_config_cleanup;
>  	}
>  
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_plane.c b/drivers/gpu/drm/exynos/exynos_drm_plane.c
> index 8371cbd..15e37a0 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_plane.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_plane.c
> @@ -139,6 +139,8 @@ int exynos_plane_mode_set(struct drm_plane *plane, struct drm_crtc *crtc,
>  			overlay->crtc_x, overlay->crtc_y,
>  			overlay->crtc_width, overlay->crtc_height);
>  
> +	plane->crtc = crtc;
> +

OK, then we can remove same code from exynos_update_plane().

One more, plane->crtc is NULL before mode_set or setplane so it's
problem if call plane->funcs->destroy with plane->crtc == NULL.
We need checking plane->crtc is NULL in exynos_disable_plane().

>  	exynos_drm_crtc_plane_mode_set(crtc, overlay);
>  
>  	return 0;
> @@ -254,25 +256,26 @@ static void exynos_plane_attach_zpos_property(struct drm_plane *plane)
>  }
>  
>  struct drm_plane *exynos_plane_init(struct drm_device *dev,
> -				    unsigned long possible_crtcs, bool priv)
> +				    unsigned long possible_crtcs,
> +				    enum drm_plane_type type)
>  {
>  	struct exynos_plane *exynos_plane;
>  	int err;
>  
>  	exynos_plane = kzalloc(sizeof(struct exynos_plane), GFP_KERNEL);
>  	if (!exynos_plane)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  
> -	err = drm_plane_init(dev, &exynos_plane->base, possible_crtcs,
> -			      &exynos_plane_funcs, formats, ARRAY_SIZE(formats),
> -			      priv);
> +	err = drm_universal_plane_init(dev, &exynos_plane->base, possible_crtcs,
> +				       &exynos_plane_funcs, formats,
> +				       ARRAY_SIZE(formats), type);
>  	if (err) {
>  		DRM_ERROR("failed to initialize plane\n");
>  		kfree(exynos_plane);
> -		return NULL;
> +		return ERR_PTR(err);
>  	}
>  
> -	if (priv)
> +	if (type == DRM_PLANE_TYPE_PRIMARY)
>  		exynos_plane->overlay.zpos = DEFAULT_ZPOS;
>  	else
>  		exynos_plane_attach_zpos_property(&exynos_plane->base);
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_plane.h b/drivers/gpu/drm/exynos/exynos_drm_plane.h
> index 84d464c..0d1986b 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_plane.h
> +++ b/drivers/gpu/drm/exynos/exynos_drm_plane.h
> @@ -17,4 +17,5 @@ int exynos_plane_mode_set(struct drm_plane *plane, struct drm_crtc *crtc,
>  void exynos_plane_commit(struct drm_plane *plane);
>  void exynos_plane_dpms(struct drm_plane *plane, int mode);
>  struct drm_plane *exynos_plane_init(struct drm_device *dev,
> -				    unsigned long possible_crtcs, bool priv);
> +				    unsigned long possible_crtcs,
> +				    enum drm_plane_type type);
> 

Thanks.
