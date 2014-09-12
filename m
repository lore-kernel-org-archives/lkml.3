Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaILIe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:34:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20749 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbaILIex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:34:53 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-f79c46d000000b84-af-5412b02b5346
Content-transfer-encoding: 8BIT
Message-id: <5412B02A.6040609@samsung.com>
Date: Fri, 12 Sep 2014 17:34:50 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 5/9] drm/exynos/crtc: fix framebuffer reference sequence
References: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
 <1410268573-2297-6-git-send-email-a.hajda@samsung.com>
In-reply-to: <1410268573-2297-6-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsWyRsSkRFd7g1CIwY67uha31p1jtbjy9T2b
	xYt7F1kszja9Ybe4vGsOm8WM8/uYLNYeuctuMWPySzYHDo/73ceZPPq2rGL0+LxJLoA5issm
	JTUnsyy1SN8ugSuj420jU8F1mYode6axNjCul+hi5OSQEDCRODC3lwXCFpO4cG89WxcjF4eQ
	wFJGiX93JrHAFH07uowdxBYSWMQoMactD8TmFRCU+DH5HlANBwezgLzEkUvZIGFmAXWJSfMW
	MUPMecUo0fr7PztEvZbE7XUvmUFsFgFVifm7foHNZwOyJ664zwZiiwqESbx4tQusRgRo0OyT
	d8AGMQucYZI4eWANI0hCWMBH4sDVnVAHVUt8aXwLNohTwFnix6d1rCANEgKn2CWevetlhNgm
	IPFt8iGwSyUEZCU2HWCGeExS4uCKGywTGMVmIflnFsI/s5D8s4CReRWjaGpBckFxUnqRoV5x
	Ym5xaV66XnJ+7iZGYKyd/vesdwfj7QPWhxgFOBiVeHgrWARDhFgTy4orcw8xmgIdMZFZSjQ5
	HxjReSXxhsZmRhamJqbGRuaWZkrivIpSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MPo0
	tli8LNkeeETz6VPhAkGbDn7OV48ubbot1/z3WpyfwpF70p7bHtwKr7wR0fom3vz/oUWbzur9
	sU6f+/nxixMFbMe368xdHLY16fe/NWpr7HoCv59s3SfBGqtpEW5ZcN/zctjkN3c9A1k1z3z2
	EbNdy3Do/Zeywz89PKOS6l71SjtLJz2tPq7EUpyRaKjFXFScCABuwWb8sAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t9jAV3tDUIhBjfvqlrcWneO1eLK1/ds
	Fi/uXWSxONv0ht3i8q45bBYzzu9jslh75C67xYzJL9kcODzudx9n8ujbsorR4/MmuQDmqAZG
	m4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygE5QUyhJz
	SoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGR1vG5kKrstU7NgzjbWBcb1EFyMn
	h4SAicS3o8vYIWwxiQv31rOB2EICixgl5rTlgdi8AoISPybfY+li5OBgFpCXOHIpGyTMLKAu
	MWneIuYuRi6g8leMEq2//7ND1GtJ3F73khnEZhFQlZi/6xcLiM0GZE9ccR9svqhAmMSLV7vA
	akSABs0+eQdsELPAGSaJkwfWMIIkhAV8JA5c3ckOcVC1xJfGt2CDOAWcJX58Wsc6gVFgFpL7
	ZiHcNwvJfQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEfyM+kdjKsaLA4xCnAwKvHw
	VrIIhgixJpYVV+YeYpTgYFYS4dVfIhQixJuSWFmVWpQfX1Sak1p8iNEU6LuJzFKiyfnAJJNX
	Em9obGJmZGlkbmhhZGyuJM57sNU6UEggPbEkNTs1tSC1CKaPiYNTqoHRImXlvL/sv2+a2jfd
	WVNwsC+ps+6ivu99Ff+vXxytLIpU1B7UhOnOE3MSvi51dOkKpRuvKr6brqny4lojlt06c1Gr
	++20t4nnBJr6WcXOZWX+lpxZ1b1lnXFH9fz6BDWtZw3/26vbWA5G3z1utmGvqcuXFdp1l8y7
	7waFXui0Vv7253F82HQlluKMREMt5qLiRADMgNE7+gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrzej,

On 2014년 09월 09일 22:16, Andrzej Hajda wrote:
> Adding reference to framebuffer should be accompanied with removing
> reference to old framebuffer assigned to the plane.
> This patch removes following warning:
> 
> [   95.038017] WARNING: CPU: 1 PID: 3067 at drivers/gpu/drm/drm_crtc.c:5115 drm_mode_config_cleanup+0x258/0x268()
> [   95.048086] Modules linked in:
> [   95.051430] CPU: 1 PID: 3067 Comm: bash Tainted: G        W      3.16.0-11355-g7a6eca5-dirty #3015
> [   95.060058] [<c0013e90>] (unwind_backtrace) from [<c0011128>] (show_stack+0x10/0x14)
> [   95.067766] [<c0011128>] (show_stack) from [<c04a5dc4>] (dump_stack+0x70/0xbc)
> [   95.074953] [<c04a5dc4>] (dump_stack) from [<c0021784>] (warn_slowpath_common+0x64/0x88)
> [   95.083005] [<c0021784>] (warn_slowpath_common) from [<c00217c4>] (warn_slowpath_null+0x1c/0x24)
> [   95.091780] [<c00217c4>] (warn_slowpath_null) from [<c0275fa0>] (drm_mode_config_cleanup+0x258/0x268)
> [   95.100983] [<c0275fa0>] (drm_mode_config_cleanup) from [<c0281724>] (exynos_drm_unload+0x38/0x50)
> [   95.109915] [<c0281724>] (exynos_drm_unload) from [<c026e248>] (drm_dev_unregister+0x24/0x98)
> [   95.118414] [<c026e248>] (drm_dev_unregister) from [<c026ecb0>] (drm_put_dev+0x28/0x64)
> [   95.126412] [<c026ecb0>] (drm_put_dev) from [<c02947c4>] (take_down_master+0x24/0x44)
> [   95.134218] [<c02947c4>] (take_down_master) from [<c0294870>] (component_del+0x8c/0xc8)
> [   95.142201] [<c0294870>] (component_del) from [<c0286c10>] (exynos_dsi_remove+0x18/0x2c)
> [   95.150294] [<c0286c10>] (exynos_dsi_remove) from [<c0299e04>] (platform_drv_remove+0x18/0x1c)
> [   95.158872] [<c0299e04>] (platform_drv_remove) from [<c02987a4>] (__device_release_driver+0x70/0xc4)
> [   95.167981] [<c02987a4>] (__device_release_driver) from [<c0298818>] (device_release_driver+0x20/0x2c)
> [   95.177268] [<c0298818>] (device_release_driver) from [<c02979d0>] (unbind_store+0x5c/0x94)
> [   95.185597] [<c02979d0>] (unbind_store) from [<c0297278>] (drv_attr_store+0x20/0x2c)
> [   95.193323] [<c0297278>] (drv_attr_store) from [<c012aa90>] (sysfs_kf_write+0x4c/0x50)
> [   95.201224] [<c012aa90>] (sysfs_kf_write) from [<c0129e94>] (kernfs_fop_write+0xc4/0x184)
> [   95.209393] [<c0129e94>] (kernfs_fop_write) from [<c00d03ec>] (vfs_write+0xa0/0x1a8)
> [   95.217111] [<c00d03ec>] (vfs_write) from [<c00d07f8>] (SyS_write+0x40/0x8c)
> [   95.224146] [<c00d07f8>] (SyS_write) from [<c000e660>] (ret_fast_syscall+0x0/0x48)
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_crtc.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
> index b68e58f..bde19f4 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
> @@ -145,10 +145,16 @@ exynos_drm_crtc_mode_set(struct drm_crtc *crtc, struct drm_display_mode *mode,
>  	if (ret)
>  		return ret;
>  
> +	/* we need to unreference current fb after replacing it with new one */
> +	old_fb = plane->fb;
> +
>  	plane->crtc = crtc;
>  	plane->fb = crtc->primary->fb;
>  	drm_framebuffer_reference(plane->fb);
>  
> +	if (old_fb)
> +		drm_framebuffer_unreference(old_fb);

This time would be a good chance that we can consider drm flip queue to
make sure that whole memory region to old_fb is scanned out completely
before dropping a reference of old_fb. the reference of old_fb should be
dropped at irq handler of each crtc devices, fimd and mixer.

Thanks,
Inki Dae

> +
>  	return 0;
>  }
>  
> 

