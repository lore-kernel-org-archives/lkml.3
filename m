Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaJBKws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:52:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:43095 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbaJBKwq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:52:46 -0400
X-AuditID: cbfee68f-f791c6d000004834-b4-542d2e7c3fc1
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <542D2E7C.1020904@samsung.com>
Date: Thu, 02 Oct 2014 19:52:44 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/exynos: fix vblank handling during dpms off
References: <542B9A0E.7020206@samsung.com>
 <1412151287-12845-1-git-send-email-a.hajda@samsung.com>
 <542D13CC.5000304@samsung.com>
In-reply-to: <542D13CC.5000304@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsWyRsSkRLdGTzfEYP9WZYtb686xWvSeO8lk
	ceXrezaLF/cuslj0LrjKZnG26Q27xeVdc9gsZpzfx2QxY/JLNgdOj+3fHrB63O8+zuTRt2UV
	o8fnTXIBLFFcNimpOZllqUX6dglcGUd27mIpWCxTsW7NIfYGxu3iXYycHBICJhJfvl1igrDF
	JC7cW8/WxcjFISSwlFHiX18nK0zR0scTWSASixglJj1pYwFJ8AoISvyYfA/MZhZQl5g0bxEz
	hC0isfj3fjYIW1ti2cLXzBDNrxgl+jb8Y4Vo1pJ4fW0uI4jNIqAqcfj5dLBmNiB74or7YM2i
	AmESL17tAopzcIgI6EhsOMkOModZYCWTRPeRfWC9wgIuElcnfGaCWNDKKLH0/BV2kAQn0OYn
	vV1gZ0sIXGOXONk7mwlim4DEt8mHWECmSgjISmw6wAzxpqTEwRU3WCYwis9C8twsJM/NQvLc
	LCTPLWBkWcUomlqQXFCclF5krFecmFtcmpeul5yfu4kRGLWn/z3r38F494D1IUYBDkYlHt6M
	Bp0QIdbEsuLK3EOMpkAXTWSWEk3OB6aGvJJ4Q2MzIwtTE1NjI3NLMyVx3oVSP4OFBNITS1Kz
	U1MLUovii0pzUosPMTJxcEo1MCbkvOe17IqQv3Rx7hyN7dKesQKb+l8z1L54/Knyfu7MSH7O
	a9KvGko/fnKvuFtb+8JH5n4D/40DK65OvJkTIdnzpNJszTu7GVuU5IMztJVsdmtJ1B8Peb3k
	zzfh4jyPG+92r3MTuGz4NCOxxk/18a0T0ik5Sdo3L+jt2ci47Y/Jdf877+o/liqxFGckGmox
	FxUnAgAKFLZr1QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t9jAd0aPd0Qg72npS1urTvHatF77iST
	xZWv79ksXty7yGLRu+Aqm8XZpjfsFpd3zWGzmHF+H5PFjMkv2Rw4PbZ/e8Dqcb/7OJNH35ZV
	jB6fN8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+ATo
	umXmAB2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcz49OwIc0GrTMWf
	1Y4NjDPFuxg5OSQETCSWPp7IAmGLSVy4t56ti5GLQ0hgEaPEpCdtYAleAUGJH5PvAdkcHMwC
	8hJHLmWDhJkF1CUmzVvEDFH/ilGib8M/Voh6LYnX1+YygtgsAqoSh59PZwax2YDsiSvus4HY
	ogJhEi9e7WIGmSkioCOx4SQ7yBxmgZVMEt1H9oH1Cgu4SFyd8JkJYkEro8TS81fYQRKcAtoS
	T3q7WCYwCsxCct8shPtmIblvASPzKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzg6H4mtYNx
	ZYPFIUYBDkYlHt6MBp0QIdbEsuLK3EOMEhzMSiK8TOq6IUK8KYmVValF+fFFpTmpxYcYTYG+
	m8gsJZqcD0w8eSXxhsYmZkaWRuaGFkbG5krivAdarQOFBNITS1KzU1MLUotg+pg4OKUaGA9x
	CbWd84t8J39yDqP1RfuGs20GS4r88kyubHYzYf+sdiZz4mmHWbdsJ1/aeuW8zIPqjA1zTNzD
	Ht6oPnA11HFZb/ia9G9ZLumORl3q3dfPSNwyel9R+9mHV8X3xqNLc70bg/QWu97hMl5y0LLs
	1ra/3jcnCpvXyt/91c0W8jVV7hLvrjtlFUosxRmJhlrMRcWJADHKdYEEAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 10월 02일 17:58, Joonyoung Shim wrote:
> Hi Andrzej,
> 
> On 10/01/2014 05:14 PM, Andrzej Hajda wrote:
>> The patch disables vblanks during dpms off only if pagefilp has
>> not been finished. It also replaces drm_vblank_off with drm_crtc_vblank_put.
>> It fixes issue with page_flip ioctl not being able to acquire vblank counter.
> 
> This problem isn't related with pageflip, it just causes from
> 7ffd7a68511c710b84db3548a1997fd2625f580a commit (drm: Always reject
> drm_vblank_get() after drm_vblank_off()).
> 
> We need to use drm_vblank_on() as a counterpart to drm_vblank_off()
> after the commit .
> 
> How about below patch?

Thanks you Joonyoung and Andrzej,

drm_vblank_on/off() are legacy api so it would be better to use
drm_vblank_crtc_on/off functions instead.

And drm_vblank_crtc_off() makes sure that the latest vblank frame count
is stored and restored by drm_vblank_crtc_on() again. So my opinion is,

static void exynos_drm_crtc_dpms(struct drm_crtc *crtc, int mode)
{
	[snip]

	if (mode > DRM_MODE_DPMS_ON) {
		/* wait for the completion of page flip. */
		if (!wait_event_timeout(exynos_crtc->pending_flip_queue,
				!atomic_read(&exynos_crtc->pending_flip),
				HZ/20))
			atomic_set(&exynos_crtc->pending_flip, 0);
		drm_crtc_vblank_off(crtc);		//<- store the latest vblank frame count.
	} else {
		drm_crtc_vblank_on(crtc);		//<- restore the vblank frame count.
	}

	[snip]
}


Tested and worked well with above patch. How about it?

Thanks,
Inki Dae

> 
>>From 6de01473746af225c688ee430123001d57d9af2a Mon Sep 17 00:00:00 2001
> From: Joonyoung Shim <jy0922.shim@samsung.com>
> Date: Thu, 2 Oct 2014 17:48:27 +0900
> Subject: [PATCH] drm/exynos: use drm_vblank_on()
> 
> We need to use drm_vblank_on() as a counterpart to drm_vblank_off()
> after the commit 7ffd7a68511c ("drm: Always reject drm_vblank_get()
> after drm_vblank_off()"). If not, drm_vblank_get() will be failed
> always after drm_vblank_off().
> 
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_crtc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
> index 8e38e9f..dfa209a 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
> @@ -71,7 +71,6 @@ static void exynos_drm_crtc_dpms(struct drm_crtc *crtc, int mode)
>  				!atomic_read(&exynos_crtc->pending_flip),
>  				HZ/20))
>  			atomic_set(&exynos_crtc->pending_flip, 0);
> -		drm_vblank_off(crtc->dev, exynos_crtc->pipe);
>  	}
>  
>  	if (manager->ops->dpms)
> @@ -90,6 +89,7 @@ static void exynos_drm_crtc_commit(struct drm_crtc *crtc)
>  	struct exynos_drm_crtc *exynos_crtc = to_exynos_crtc(crtc);
>  	struct exynos_drm_manager *manager = exynos_crtc->manager;
>  
> +	drm_vblank_on(crtc->dev, exynos_crtc->pipe);
>  	exynos_drm_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
>  
>  	exynos_plane_commit(crtc->primary);
> @@ -177,10 +177,12 @@ static int exynos_drm_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
>  
>  static void exynos_drm_crtc_disable(struct drm_crtc *crtc)
>  {
> +	struct exynos_drm_crtc *exynos_crtc = to_exynos_crtc(crtc);
>  	struct drm_plane *plane;
>  	int ret;
>  
>  	exynos_drm_crtc_dpms(crtc, DRM_MODE_DPMS_OFF);
> +	drm_vblank_off(crtc->dev, exynos_crtc->pipe);
>  
>  	drm_for_each_legacy_plane(plane, &crtc->dev->mode_config.plane_list) {
>  		if (plane->crtc != crtc)
> 

