Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbaILJWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:22:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9895 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbaILJWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:22:01 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-f79ce6d00000115a-48-5412bb367fe4
Content-transfer-encoding: 8BIT
Message-id: <5412BB35.7050309@samsung.com>
Date: Fri, 12 Sep 2014 18:21:57 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Andrzej Hajda <a.hajda@samsung.com>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        open list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 5/9] drm/exynos/crtc: fix framebuffer reference sequence
References: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
 <1410268573-2297-6-git-send-email-a.hajda@samsung.com>
 <5412B02A.6040609@samsung.com> <20140912085710.GD4740@phenom.ffwll.local>
In-reply-to: <20140912085710.GD4740@phenom.ffwll.local>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42JZI2JSomu2WyjEYONHDotb686xWlz5+p7N
	4mzTG3aLy7vmsFnMOL+PyWLtkbvsFjMmv2RzYPe4332cyaNvyypGj8+b5AKYo7hsUlJzMstS
	i/TtErgylsx8z1awRq2ic6FEA+NyhS5GTg4JAROJ702L2SBsMYkL99YD2VwcQgJLGSXO77/F
	ClN0/PYKqMR0RomLm1+xgCR4BQQlfky+B2RzcDALyEscuZQNEmYWUJeYNG8RM0T9K0aJxmWt
	UPVaEg+uLwcbyiKgKnF98wowmw3InrjiPtgVogJhEi9e7QJrFhE4ziSx+9x1sGZhAR+JA1d3
	skNMPc4o0Xy/lRVkM6eAucSt9TEgcQmBdewS/x/fZIPYICDxbfIhsOskBGQlNh1ghvhGUuLg
	ihssExhFZyH5YRbCD7OQ/LCAkXkVo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRmAknf73bMIO
	xnsHrA8xCnAwKvHwVrAIhgixJpYVV+YeYjQFOmIis5Rocj4wXvNK4g2NzYwsTE1MjY3MLc2U
	xHlfS/0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAoP/0LQ/pWTQtn19dvDJ1M/I5X77jk
	dGNy6t5HUQ+2nDqwS3TWzPfrLn1WPzCTIcchIv3TxqsvFsySkirqLtvy5qB147s721cfn3mC
	LW/bndZrC68s33JuTlxlVXnSN9lvX7nelv5j8FMQFdnOsfncxrlP3t+6/oorTvF67cr6ZzI6
	mlZ3gswNHJRYijMSDbWYi4oTAefGzLOfAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jQV2z3UIhBjMsLG6tO8dqceXrezaL
	s01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B3eN+93Emj74tqxg9Pm+SC2COamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMWDLzPVvBGrWKzoUSDYzLFboYOTkkBEwkjt9e
	wQZhi0lcuLceyObiEBKYzihxcfMrFpAEr4CgxI/J94BsDg5mAXmJI5eyQcLMAuoSk+YtYoao
	f8Uo0bisFapeS+LB9eWsIDaLgKrE9c0rwGw2IHviivtgy0QFwiRevNoF1iwicJxJYve562DN
	wgI+Egeu7mSHmHqcUaL5fisryGZOAXOJW+tjJjDyz0Jy0yyEm2YhuWkBI/MqRtHUguSC4qT0
	XCO94sTc4tK8dL3k/NxNjOAofSa9g3FVg8UhRgEORiUe3koWwRAh1sSy4srcQ4wSHMxKIrw/
	twmFCPGmJFZWpRblxxeV5qQWH2I0BfpoIrOUaHI+MIHklcQbGpuYGVkamRtaGBmbK4nzHmy1
	DhQSSE8sSc1OTS1ILYLpY+LglGpgzHS5vyFNpF1qwgu+9e1Jb7Nv3A7dsvbWHM2PIY+k15d1
	n+Dr4leIbN+z98wHE3HjpqBJd+Y+u7ZsD8u/rac5WKo97ptZbt0SNrlUhkdP6ey2gOKzn7Y9
	SXecIMHpXpjx4dRePuWAXO7+tcXXP9WdcFzCMX3ebs/fablLmuZUJPOWuTiV3hSPUmIpzkg0
	1GIuKk4EALwZGLroAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 09월 12일 17:57, Daniel Vetter wrote:
> On Fri, Sep 12, 2014 at 05:34:50PM +0900, Inki Dae wrote:
>> Hi Andrzej,
>>
>> On 2014년 09월 09일 22:16, Andrzej Hajda wrote:
>>> Adding reference to framebuffer should be accompanied with removing
>>> reference to old framebuffer assigned to the plane.
>>> This patch removes following warning:
>>>
>>> [   95.038017] WARNING: CPU: 1 PID: 3067 at drivers/gpu/drm/drm_crtc.c:5115 drm_mode_config_cleanup+0x258/0x268()
>>> [   95.048086] Modules linked in:
>>> [   95.051430] CPU: 1 PID: 3067 Comm: bash Tainted: G        W      3.16.0-11355-g7a6eca5-dirty #3015
>>> [   95.060058] [<c0013e90>] (unwind_backtrace) from [<c0011128>] (show_stack+0x10/0x14)
>>> [   95.067766] [<c0011128>] (show_stack) from [<c04a5dc4>] (dump_stack+0x70/0xbc)
>>> [   95.074953] [<c04a5dc4>] (dump_stack) from [<c0021784>] (warn_slowpath_common+0x64/0x88)
>>> [   95.083005] [<c0021784>] (warn_slowpath_common) from [<c00217c4>] (warn_slowpath_null+0x1c/0x24)
>>> [   95.091780] [<c00217c4>] (warn_slowpath_null) from [<c0275fa0>] (drm_mode_config_cleanup+0x258/0x268)
>>> [   95.100983] [<c0275fa0>] (drm_mode_config_cleanup) from [<c0281724>] (exynos_drm_unload+0x38/0x50)
>>> [   95.109915] [<c0281724>] (exynos_drm_unload) from [<c026e248>] (drm_dev_unregister+0x24/0x98)
>>> [   95.118414] [<c026e248>] (drm_dev_unregister) from [<c026ecb0>] (drm_put_dev+0x28/0x64)
>>> [   95.126412] [<c026ecb0>] (drm_put_dev) from [<c02947c4>] (take_down_master+0x24/0x44)
>>> [   95.134218] [<c02947c4>] (take_down_master) from [<c0294870>] (component_del+0x8c/0xc8)
>>> [   95.142201] [<c0294870>] (component_del) from [<c0286c10>] (exynos_dsi_remove+0x18/0x2c)
>>> [   95.150294] [<c0286c10>] (exynos_dsi_remove) from [<c0299e04>] (platform_drv_remove+0x18/0x1c)
>>> [   95.158872] [<c0299e04>] (platform_drv_remove) from [<c02987a4>] (__device_release_driver+0x70/0xc4)
>>> [   95.167981] [<c02987a4>] (__device_release_driver) from [<c0298818>] (device_release_driver+0x20/0x2c)
>>> [   95.177268] [<c0298818>] (device_release_driver) from [<c02979d0>] (unbind_store+0x5c/0x94)
>>> [   95.185597] [<c02979d0>] (unbind_store) from [<c0297278>] (drv_attr_store+0x20/0x2c)
>>> [   95.193323] [<c0297278>] (drv_attr_store) from [<c012aa90>] (sysfs_kf_write+0x4c/0x50)
>>> [   95.201224] [<c012aa90>] (sysfs_kf_write) from [<c0129e94>] (kernfs_fop_write+0xc4/0x184)
>>> [   95.209393] [<c0129e94>] (kernfs_fop_write) from [<c00d03ec>] (vfs_write+0xa0/0x1a8)
>>> [   95.217111] [<c00d03ec>] (vfs_write) from [<c00d07f8>] (SyS_write+0x40/0x8c)
>>> [   95.224146] [<c00d07f8>] (SyS_write) from [<c000e660>] (ret_fast_syscall+0x0/0x48)
>>>
>>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>>> ---
>>>  drivers/gpu/drm/exynos/exynos_drm_crtc.c | 6 ++++++
>>>  1 file changed, 6 insertions(+)
>>>
>>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
>>> index b68e58f..bde19f4 100644
>>> --- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
>>> +++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
>>> @@ -145,10 +145,16 @@ exynos_drm_crtc_mode_set(struct drm_crtc *crtc, struct drm_display_mode *mode,
>>>  	if (ret)
>>>  		return ret;
>>>  
>>> +	/* we need to unreference current fb after replacing it with new one */
>>> +	old_fb = plane->fb;
>>> +
>>>  	plane->crtc = crtc;
>>>  	plane->fb = crtc->primary->fb;
>>>  	drm_framebuffer_reference(plane->fb);
>>>  
>>> +	if (old_fb)
>>> +		drm_framebuffer_unreference(old_fb);
>>
>> This time would be a good chance that we can consider drm flip queue to
>> make sure that whole memory region to old_fb is scanned out completely
>> before dropping a reference of old_fb. the reference of old_fb should be
>> dropped at irq handler of each crtc devices, fimd and mixer.
> 
> Generally it's not a good idea to drop fb references from irq context,
> since if you actually drop the last reference it'll blow up: fb cleanup
> needs a bunch of mutexes.

Actually, drm_flip_work_commit function will be called at irq context so
the reference will be dropped by work queue handler so mutex lock would
be required before dropping the reference. My concern was that gem
memory may be freed before the memory region is scanned out completely
so I thought we need to make sure to scan out completely somehow.

> 
> Also the drm core really should be taking care of this for you, you only
> need to grab references yourself for async flips if you want the buffer to
> survive a bit. crtc_mode_set has not need for this. I expect that the
> refcounting bug is somewhere else, at least from my experience chasing
> such issues in i915 ;-)

Thanks for comments. Yes, there may be refcounting bug somewhere else if
drm core makes sure to take care of this. It seems to need more checking.

Thanks,
Inki Dae

> -Daniel
> 

