Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbaISL30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:29:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60838 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaISL3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:29:24 -0400
X-AuditID: cbfee690-f79ce6d00000115a-e0-541c139122f7
Message-id: <541C1392.6070801@samsung.com>
Date: Fri, 19 Sep 2014 20:29:22 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101
 Thunderbird/31.1.1
MIME-version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>, Inki Dae <inki.dae@samsung.com>
Cc: "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DRM DRIVERS FOR E..." <dri-devel@lists.freedesktop.org>,
        drake@endlessm.com, Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, m.szyprowski@samsung.com
Subject: Re: [PATCH] drm/exynos: switch to universal plane API
References: <1411046223-22703-1-git-send-email-a.hajda@samsung.com>
 <541B8093.6040807@samsung.com> <541C0B5B.7010100@samsung.com>
 <541C0F7E.1080808@samsung.com>
In-reply-to: <541C0F7E.1080808@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsWyRsSkRHeisEyIwab5Sha31p1jtXg0/zGz
	xZWv79ksJt2fwGLRu+Aqm8XZpjfsFpd3zWGzmHF+H5PF2iN32S1mTH7J5sDlseh7lsf97uNM
	Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXx9NoTpoL1vhUPDk9ma2A8Yt/FyMkhIWAicfPg
	FzYIW0ziwr31QDYXh5DAUkaJT2fOssAU3b/9lQkiMZ1RYs67TywQzmtGid87e1lBqngFtCSa
	bzSCjWIRUJWYfvQ4mM0moCdxZ9txoG4ODlGBMIm/t7khygUlfky+B7ZARMBDYv6bPcwgM5kF
	XjFJrG3/yAiSEBawk/g18yaYLSSwhFHi0GJnEJtTQFtiW/8pFpCZzEDz71/UAgkzC8hLbF7z
	FmyOhMA9donrHSeZIe4RkPg2+RBYvYSArMSmA8wQj0lKHFxxg2UCo9gsJCfNQpg6C8nUBYzM
	qxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzEC4/D0v2cTdjDeO2B9iFGAg1GJh9cjTTpEiDWx
	rLgy9xCjKdARE5mlRJPzgdGeVxJvaGxmZGFqYmpsZG5ppiTO+1rqZ7CQQHpiSWp2ampBalF8
	UWlOavEhRiYOTqkGxszIuIpOnw3F3OvLktdxrj/WcURQffnD7H06eTGPfrx/cDP7yoK9/vN4
	n/r7NFk8nxyr5XfB2Cf7VfTnDvb66xM9TnN86mPeFHG7Ysk9v4a3fmek7Fuvxv+//lr9wt8X
	p9M6as7EJ05LsJjy83iC/Ppls7mWTFFkDNwfLrxi9vnmg5se3GQKuK3EUpyRaKjFXFScCABf
	Nz1bvgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jQd2JwjIhBrffiFvcWneO1eLR/MfM
	Fle+vmezmHR/AotF74KrbBZnm96wW1zeNYfNYsb5fUwWa4/cZbeYMfklmwOXx6LvWR73u48z
	efRtWcXo8XmTXABLVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqt
	kotPgK5bZg7QQUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjKfXnjAV
	rPeteHB4MlsD4xH7LkZODgkBE4n7t78yQdhiEhfurWfrYuTiEBKYzigx590nFgjnNaPE7529
	rCBVvAJaEs03GtlAbBYBVYnpR4+D2WwCehJ3th0HmsTBISoQJvH3NjdEuaDEj8n3WEBsEQEP
	iflv9jCDzGQWeMUksbb9IyNIQljATuLXzJtgtpDAEkaJQ4udQWxOAW2Jbf2nWEBmMgPNv39R
	CyTMLCAvsXnNW+YJjAKzkKyYhVA1C0nVAkbmVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB
	Uf5MegfjqgaLQ4wCHIxKPLweadIhQqyJZcWVuYcYJTiYlUR4L/4DCvGmJFZWpRblxxeV5qQW
	H2I0Bfp/IrOUaHI+MAHllcQbGpuYGVkamRtaGBmbK4nzHmy1DhQSSE8sSc1OTS1ILYLpY+Lg
	lGpgTLdMuXLTOyGr7OdOOZP8BXfErATkLfa6OT+Zc7Tzpf2foqsrWhUuJJkLspyctmzX28Vn
	nllYBzDf4E6eZh7M6Z2RnNGw4ULGMbO9ql4ncjrtD0nlvv0t3S7aV1J42aXt95/U6XbcjPYl
	AexJ/5zum37te3xMb4H7X80ckYK+2V8Fyy7J2P1RYinOSDTUYi4qTgQAs4AzPwgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/19/2014 08:11 PM, Joonyoung Shim wrote:
> Hi,
> 
> On 09/19/2014 07:54 PM, Andrzej Hajda wrote:
>> On 09/19/2014 03:02 AM, Joonyoung Shim wrote:
>>> Hi Andrzej,
>>>
>>> On 09/18/2014 10:17 PM, Andrzej Hajda wrote:
>>>> The patch replaces legacy functions
>>>> drm_plane_init() / drm_crtc_init() with
>>>> drm_universal_plane_init() and drm_crtc_init_with_planes().
>>>> It allows to replace fake primary plane with the real one.
>>>>
>>>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>>>> ---
>>>> Hi Inki,
>>>>
>>>> I have tested this patch with trats board, it looks OK.
>>>> As a side effect it should solve fb refcounting issues
>>>> reported by me and Daniel Drake.
>>>>
>>>> Regards
>>>> Andrzej
>>>> ---
>>>>  drivers/gpu/drm/exynos/exynos_drm_crtc.c  | 63 ++++++++++++++++---------------
>>>>  drivers/gpu/drm/exynos/exynos_drm_drv.c   |  5 ++-
>>>>  drivers/gpu/drm/exynos/exynos_drm_plane.c | 17 +++++----
>>>>  drivers/gpu/drm/exynos/exynos_drm_plane.h |  3 +-
>>>>  4 files changed, 47 insertions(+), 41 deletions(-)
>>>>
>>>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
>>>> index b68e58f..d2f713e 100644
>>>> --- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
>>>> +++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
>>>> @@ -32,7 +32,6 @@ enum exynos_crtc_mode {
>>>>   * Exynos specific crtc structure.
>>>>   *
>>>>   * @drm_crtc: crtc object.
>>>> - * @drm_plane: pointer of private plane object for this crtc
>>>>   * @manager: the manager associated with this crtc
>>>>   * @pipe: a crtc index created at load() with a new crtc object creation
>>>>   *	and the crtc object would be set to private->crtc array
>>>> @@ -46,7 +45,6 @@ enum exynos_crtc_mode {
>>>>   */
>>>>  struct exynos_drm_crtc {
>>>>  	struct drm_crtc			drm_crtc;
>>>> -	struct drm_plane		*plane;
>>>>  	struct exynos_drm_manager	*manager;
>>>>  	unsigned int			pipe;
>>>>  	unsigned int			dpms;
>>>> @@ -94,12 +92,12 @@ static void exynos_drm_crtc_commit(struct drm_crtc *crtc)
>>>>  
>>>>  	exynos_drm_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
>>>>  
>>>> -	exynos_plane_commit(exynos_crtc->plane);
>>>> +	exynos_plane_commit(crtc->primary);
>>>>  
>>>>  	if (manager->ops->commit)
>>>>  		manager->ops->commit(manager);
>>>>  
>>>> -	exynos_plane_dpms(exynos_crtc->plane, DRM_MODE_DPMS_ON);
>>>> +	exynos_plane_dpms(crtc->primary, DRM_MODE_DPMS_ON);
>>>>  }
>>>>  
>>>>  static bool
>>>> @@ -123,10 +121,9 @@ exynos_drm_crtc_mode_set(struct drm_crtc *crtc, struct drm_display_mode *mode,
>>>>  {
>>>>  	struct exynos_drm_crtc *exynos_crtc = to_exynos_crtc(crtc);
>>>>  	struct exynos_drm_manager *manager = exynos_crtc->manager;
>>>> -	struct drm_plane *plane = exynos_crtc->plane;
>>>> +	struct drm_framebuffer *fb = crtc->primary->fb;
>>>>  	unsigned int crtc_w;
>>>>  	unsigned int crtc_h;
>>>> -	int ret;
>>>>  
>>>>  	/*
>>>>  	 * copy the mode data adjusted by mode_fixup() into crtc->mode
>>>> @@ -134,29 +131,21 @@ exynos_drm_crtc_mode_set(struct drm_crtc *crtc, struct drm_display_mode *mode,
>>>>  	 */
>>>>  	memcpy(&crtc->mode, adjusted_mode, sizeof(*adjusted_mode));
>>>>  
>>>> -	crtc_w = crtc->primary->fb->width - x;
>>>> -	crtc_h = crtc->primary->fb->height - y;
>>>> +	crtc_w = fb->width - x;
>>>> +	crtc_h = fb->height - y;
>>>>  
>>>>  	if (manager->ops->mode_set)
>>>>  		manager->ops->mode_set(manager, &crtc->mode);
>>>>  
>>>> -	ret = exynos_plane_mode_set(plane, crtc, crtc->primary->fb, 0, 0, crtc_w, crtc_h,
>>>> -				    x, y, crtc_w, crtc_h);
>>>> -	if (ret)
>>>> -		return ret;
>>>> -
>>>> -	plane->crtc = crtc;
>>>> -	plane->fb = crtc->primary->fb;
>>>> -	drm_framebuffer_reference(plane->fb);
>>>> -
>>>> -	return 0;
>>>> +	return exynos_plane_mode_set(crtc->primary, crtc, fb, 0, 0,
>>>> +				     crtc_w, crtc_h, x, y, crtc_w, crtc_h);
>>>>  }
>>>>  
>>>>  static int exynos_drm_crtc_mode_set_commit(struct drm_crtc *crtc, int x, int y,
>>>>  					  struct drm_framebuffer *old_fb)
>>>>  {
>>>>  	struct exynos_drm_crtc *exynos_crtc = to_exynos_crtc(crtc);
>>>> -	struct drm_plane *plane = exynos_crtc->plane;
>>>> +	struct drm_framebuffer *fb = crtc->primary->fb;
>>>>  	unsigned int crtc_w;
>>>>  	unsigned int crtc_h;
>>>>  	int ret;
>>>> @@ -167,11 +156,11 @@ static int exynos_drm_crtc_mode_set_commit(struct drm_crtc *crtc, int x, int y,
>>>>  		return -EPERM;
>>>>  	}
>>>>  
>>>> -	crtc_w = crtc->primary->fb->width - x;
>>>> -	crtc_h = crtc->primary->fb->height - y;
>>>> +	crtc_w = fb->width - x;
>>>> +	crtc_h = fb->height - y;
>>>>  
>>>> -	ret = exynos_plane_mode_set(plane, crtc, crtc->primary->fb, 0, 0, crtc_w, crtc_h,
>>>> -				    x, y, crtc_w, crtc_h);
>>>> +	ret = exynos_plane_mode_set(crtc->primary, crtc, fb, 0, 0,
>>>> +				    crtc_w, crtc_h, x, y, crtc_w, crtc_h);
>>>>  	if (ret)
>>>>  		return ret;
>>>>  
>>>> @@ -279,6 +268,7 @@ static void exynos_drm_crtc_destroy(struct drm_crtc *crtc)
>>>>  
>>>>  	private->crtc[exynos_crtc->pipe] = NULL;
>>>>  
>>>> +	crtc->primary->funcs->destroy(crtc->primary);
>>> This is unnecessary.
>>
>> The question is how these object should be destroyed. In current code
>> crtc is destroyed in fimd_unbind and it is called before
>> drm_mode_config_cleanup
>> which destroys all planes.
>> In such case primary plane will stay with .crtc pointing to non-existing
>> crtc.
>> Maybe performing crtcs cleanup after planes cleanup is better solution???
> 
> I think it's wrong to call destroy function of crtc in fimd_unbind, all
> objects should be destroyed by drm_mode_config_cleanup except error
> cases while initializing.
> 
>>
>>>
>>>>  	drm_crtc_cleanup(crtc);
>>>>  	kfree(exynos_crtc);
>>>>  }
>>>> @@ -304,8 +294,7 @@ static int exynos_drm_crtc_set_property(struct drm_crtc *crtc,
>>>>  			exynos_drm_crtc_commit(crtc);
>>>>  			break;
>>>>  		case CRTC_MODE_BLANK:
>>>> -			exynos_plane_dpms(exynos_crtc->plane,
>>>> -					  DRM_MODE_DPMS_OFF);
>>>> +			exynos_plane_dpms(crtc->primary, DRM_MODE_DPMS_OFF);
>>>>  			break;
>>>>  		default:
>>>>  			break;
>>>> @@ -351,8 +340,10 @@ static void exynos_drm_crtc_attach_mode_property(struct drm_crtc *crtc)
>>>>  int exynos_drm_crtc_create(struct exynos_drm_manager *manager)
>>>>  {
>>>>  	struct exynos_drm_crtc *exynos_crtc;
>>>> +	struct drm_plane *plane;
>>>>  	struct exynos_drm_private *private = manager->drm_dev->dev_private;
>>>>  	struct drm_crtc *crtc;
>>>> +	int ret;
>>>>  
>>>>  	exynos_crtc = kzalloc(sizeof(*exynos_crtc), GFP_KERNEL);
>>>>  	if (!exynos_crtc)
>>>> @@ -364,11 +355,11 @@ int exynos_drm_crtc_create(struct exynos_drm_manager *manager)
>>>>  	exynos_crtc->dpms = DRM_MODE_DPMS_OFF;
>>>>  	exynos_crtc->manager = manager;
>>>>  	exynos_crtc->pipe = manager->pipe;
>>>> -	exynos_crtc->plane = exynos_plane_init(manager->drm_dev,
>>>> -				1 << manager->pipe, true);
>>>> -	if (!exynos_crtc->plane) {
>>>> -		kfree(exynos_crtc);
>>>> -		return -ENOMEM;
>>>> +	plane = exynos_plane_init(manager->drm_dev, 1 << manager->pipe,
>>>> +				  DRM_PLANE_TYPE_PRIMARY);
>>>> +	if (IS_ERR(plane)) {
>>>> +		ret = PTR_ERR(plane);
>>>> +		goto err_plane;
>>>>  	}
>>>>  
>>>>  	manager->crtc = &exynos_crtc->drm_crtc;
>>>> @@ -376,12 +367,22 @@ int exynos_drm_crtc_create(struct exynos_drm_manager *manager)
>>>>  
>>>>  	private->crtc[manager->pipe] = crtc;
>>>>  
>>>> -	drm_crtc_init(manager->drm_dev, crtc, &exynos_crtc_funcs);
>>>> +	ret = drm_crtc_init_with_planes(manager->drm_dev, crtc, plane, NULL,
>>>> +					&exynos_crtc_funcs);
>>>> +	if (ret < 0)
>>>> +		goto err_crtc;
>>>> +
>>>>  	drm_crtc_helper_add(crtc, &exynos_crtc_helper_funcs);
>>>>  
>>>>  	exynos_drm_crtc_attach_mode_property(crtc);
>>>>  
>>>>  	return 0;
>>>> +
>>>> +err_crtc:
>>>> +	plane->funcs->destroy(plane);
>>>> +err_plane:
>>>> +	kfree(exynos_crtc);
>>>> +	return ret;
>>>>  }
>>>>  
>>>>  int exynos_drm_crtc_enable_vblank(struct drm_device *dev, int pipe)
>>>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
>>>> index 9b00e4e..a439452 100644
>>>> --- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
>>>> +++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
>>>> @@ -86,8 +86,9 @@ static int exynos_drm_load(struct drm_device *dev, unsigned long flags)
>>>>  		struct drm_plane *plane;
>>>>  		unsigned long possible_crtcs = (1 << MAX_CRTC) - 1;
>>>>  
>>>> -		plane = exynos_plane_init(dev, possible_crtcs, false);
>>>> -		if (!plane)
>>>> +		plane = exynos_plane_init(dev, possible_crtcs,
>>>> +					  DRM_PLANE_TYPE_OVERLAY);
>>>> +		if (IS_ERR(plane))
>>>>  			goto err_mode_config_cleanup;
>>>>  	}
>>>>  
>>>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_plane.c b/drivers/gpu/drm/exynos/exynos_drm_plane.c
>>>> index 8371cbd..15e37a0 100644
>>>> --- a/drivers/gpu/drm/exynos/exynos_drm_plane.c
>>>> +++ b/drivers/gpu/drm/exynos/exynos_drm_plane.c
>>>> @@ -139,6 +139,8 @@ int exynos_plane_mode_set(struct drm_plane *plane, struct drm_crtc *crtc,
>>>>  			overlay->crtc_x, overlay->crtc_y,
>>>>  			overlay->crtc_width, overlay->crtc_height);
>>>>  
>>>> +	plane->crtc = crtc;
>>>> +
>>> OK, then we can remove same code from exynos_update_plane().
>>
>> Right.
>>
>>>
>>> One more, plane->crtc is NULL before mode_set or setplane so it's
>>> problem if call plane->funcs->destroy with plane->crtc == NULL.
>>> We need checking plane->crtc is NULL in exynos_disable_plane().
>>
>> I can simply add checks, but why we allow the plane with NULL crtc to be
>> enabled?
>>
> 
> I mean plane disable case, not enable case.

OK, i am missing plane DPMS, the plane DPMS is not ON before mode_set
and setplane so plane->crtc is not referenced while disable plane.

Please ignore this comment.

Thanks.
