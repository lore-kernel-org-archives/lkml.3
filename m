Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbaEHEdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 00:33:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15295 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaEHEdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 00:33:09 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-53-536b090324e7
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <536B0900.10204@samsung.com>
Date: Thu, 08 May 2014 13:33:04 +0900
From: Seung-Woo Kim <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Paul <seanpaul@chromium.org>,
        =?UTF-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marcheu@chromium.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [PATCH 2/4] drm/exynos/mixer: use MXR_GRP_SXY_SY
References: <1399217181-26442-1-git-send-email-djkurtz@chromium.org>
 <1399217181-26442-3-git-send-email-djkurtz@chromium.org>
 <5369C13C.3080506@samsung.com>
 <CAGS+omAbuzRpNDvB6eTw67Dcv3WMdWF3yz+bU5p3j5JRourOyw@mail.gmail.com>
In-reply-to: <CAGS+omAbuzRpNDvB6eTw67Dcv3WMdWF3yz+bU5p3j5JRourOyw@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42JZI2JSqMvMmR1scKKX16L33Ekmi8YZ81kt
	rnx9z2Yx6f4EFosX9y6yWPQuuMpmcbbpDbvFpsfXWC0u75rDZjHj/D4mi3mHfjNa3N1wltFi
	xuSXbA68HrMbLrJ4bP/2gNXjfvdxJo/NS+o9+rasYvT4vEkugC2KyyYlNSezLLVI3y6BK+Pz
	mlPsBZMUK/o6drI3MF6Q7GLk5JAQMJFYdfEpK4QtJnHh3nq2LkYuDiGBpYwSv15sYIcp2vP+
	FitEYjqjxNa+s0wgCV4BQYkfk++xgNjMAuoSk+YtYoawRST+/z0BZWtLLFv4mhmi+TUj0KTX
	LBDNGhLHTp8D28AioCox7ctSsDibgI7E/iW/wU4SElCQuDLxGFANB4eoQJjEzs3pIKYI0K5f
	N5xARjILnGaROLjyDtguYQFbie62F+wQu54D7fqwE2w+p0CwRMPvX4wgCQmBiRwSxxZdY4ZY
	LCDxbfIhFpCpEgKyEpsOMEN8LClxcMUNlgmMErOQ/DkLyZ+zkPw5C8mfCxhZVjGKphYkFxQn
	pReZ6BUn5haX5qXrJefnbmIEJoHT/55N2MF474D1IcZkoPUTmaVEk/OBSSSvJN7Q2MzIwtTE
	1NjI3NKMNGElcV61R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhzBJpnx6yVOh4yrXua
	5xuNz1qBjovnCxpvm9T595G6r/Kfpmfii9+mV+wuV619dffI1FzJpTuON+dZ6tf+af+1okby
	wpSdJw+sLzu8in2h+z9WO6E5jgpbi+2PdX0V/7cimWGnHlPG3uNtzJ809Vmrms/91luxf//v
	xPB/11aKPrN5+Plr5bEvSizFGYmGWsxFxYkAWeFx5hgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jQV1mzuxgg7NvmCx6z51ksmicMZ/V
	4srX92wWk+5PYLF4ce8ii0XvgqtsFmeb3rBbbHp8jdXi8q45bBYzzu9jsph36Dejxd0NZxkt
	Zkx+yebA6zG74SKLx/ZvD1g97ncfZ/LYvKTeo2/LKkaPz5vkAtiiGhhtMlITU1KLFFLzkvNT
	MvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AuVVIoS8wpBQoFJBYXK+nbYZoQ
	GuKmawHTGKHrGxIE12NkgAYS1jBm7Fp5h6Vgi0LFymtv2RoYP0l0MXJySAiYSOx5f4sVwhaT
	uHBvPVsXIxeHkMB0RomtfWeZQBK8AoISPybfY+li5OBgFpCXOHIpGyTMLKAuMWneImaI+teM
	QINes0DUa0gcO32OHcRmEVCVmPZlKVicTUBHYv+S32DLhAQUJK5MPMYOMlNUIExi5+Z0EFME
	aOavG04gI5kFTrNIHFx5hxmkXFjAVqK77QU7xK7nQLs+7ASbzykQLNHw+xfjBEbBWUhOnYVw
	6iwkpy5gZF7FKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZwunkntYFzZYHGIUYCDUYmHN8M5
	K1iINbGsuDL3EKMEB7OSCK//ZKAQb0piZVVqUX58UWlOavEhxmSgRycyS4km5wNTWV5JvKGx
	iZmRpZG5oYWRsTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MNal1C1rbe7PO8ddeTPi
	8X3hYps0HXnld9+UeXn6v/bHWNQtSP05o2hjziyRrQq3/5Ud/vlTcNepiiqO+E0dVeyRkYXF
	xuJFu2/l/w/g3h3x45RWqLfJLP78fXkP3/b/YmFQtjcWO7/9ai334TlGK11/Od1Jct+Q/LzB
	cW9oJIeS2JzLFYmBSizFGYmGWsxFxYkAL7v3OVsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Daniel,

On 2014년 05월 07일 23:14, Daniel Kurtz wrote:
> On Wed, May 7, 2014 at 1:14 PM, Seung-Woo Kim <sw0312.kim@samsung.com> wrote:
>> Hi Daniel,
>>
>> On 2014년 05월 05일 00:26, Daniel Kurtz wrote:
>>> Mixer hardware supports offsetting dma from start of source buffer using
>>> the MXR_GRP_SXY register.
>>>
>>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>>> ---
>>>  drivers/gpu/drm/exynos/exynos_mixer.c | 8 +++-----
>>>  1 file changed, 3 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
>>> index 475eb49..40cf39b 100644
>>> --- a/drivers/gpu/drm/exynos/exynos_mixer.c
>>> +++ b/drivers/gpu/drm/exynos/exynos_mixer.c
>>> @@ -529,13 +529,11 @@ static void mixer_graph_buffer(struct mixer_context *ctx, int win)
>>>
>>>       dst_x_offset = win_data->crtc_x;
>>>       dst_y_offset = win_data->crtc_y;
>>> +     src_x_offset = win_data->fb_x;
>>> +     src_y_offset = win_data->fb_y;
>>>
>>>       /* converting dma address base and source offset */
>>> -     dma_addr = win_data->dma_addr
>>> -             + (win_data->fb_x * win_data->bpp >> 3)
>>> -             + (win_data->fb_y * win_data->fb_width * win_data->bpp >> 3);
>>> -     src_x_offset = 0;
>>> -     src_y_offset = 0;
>>> +     dma_addr = win_data->dma_addr;
>>
>> Basically, you are right and source offset register can be used. But
>> because of limitation of resolution for mixer up to 1920x1080, I
>> considered modified soruce dma address to set one frame buffer, which is
>> bigger than 1920x1080, on to both fimd and hdmi.
> 
> Hi Seung-Woo,
> 
> I do not see why the maximum MIXER resolution matters for choosing
> between offsetting BASE or using SXY.
> 
> Let's say you have one big 1920x1908 framebuffer, with a span of 1920,
> starting at dma_addr (there is no extra padding at the end of the
> line).
> Let's say you wanted the mixer to scan out 1920x1080 pixels starting
> from (0, 800) in the framebuffer, and start drawing them at (0,0) on
> the screen.
> 
> What we currently do is:
>   BASE = dma_addr + (800 * 1080 * 4)
>   SPAN = 1920
>   SXY = SX(0) | SY(0)
>   WH = W(1920) | H(1080)
>   DXY = DX(0) | DY(0)
> 
> I am proposing we do:
>   BASE = dma_addr
>   SPAN = 1920
>   SXY = SX(0) | SY(800)
>   WH = W(1920) | H(1080)
>   DXY = DX(0) | DY(0)
> 
> In both cases, the mixer resolution is 1920x1080.

In my test to show each half of big one framebuffer (3840 x 1080) to
FIMD from 0 to 1079 and MIXER from 1080 to 3839 with exynos4210 and
exynos4412, it was failed to show proper hdmi display. Also it is same
for framebuffer (1920 x 2160). AFAIK, it is mainly because mixer dma has
limitation of dma memory size.

In this case, I set register as like:
  BASE = dma_addr /* 3840 x 1080 x 4 */
  SPAN = 3840
  SXY = SX(1920) | SY(0)
  WH = W(1920) | H(1080)
  DXY = DX(0) | DY(0)
or:
  BASE = dma_addr /* 1920 x 2160 x 4 */
  SPAN = 1920
  SXY = SX(0) | SY(1080)
  WH = W(1920) | H(1080)
  DXY = DX(0) | DY(0)
but these two setting did not show hdmi display as I expected. So I used
modified dma address.

> 
> My motivation for wanting to program an un-modified dma_addr into BASE
> is so we can then just check BASE_S to determine from which buffer the
> mixer is actively being scanned out without worrying about the source
> offset, since the source offset can change for a given framebuffer
> (for example, when doing panning, or if an overlay is used for a HW
> cursor).

Actually, this patch is exactly same with my first implementation, so I
completely understand your motivation. Anyway, I was focus on extended
displays with one buffer, so I wrote modified dma base address.

Thanks and Regards,
- Seung-Woo Kim

> 
> Best Regards,
> -Daniel
> 
>>
>> Regards,
>> - Seung-Woo Kim
>>
>>>
>>>       if (win_data->scan_flags & DRM_MODE_FLAG_INTERLACE)
>>>               ctx->interlace = true;
>>>
>>
>> --
>> Seung-Woo Kim
>> Samsung Software R&D Center
>> --
>>
> 

-- 
Seung-Woo Kim
Samsung Software R&D Center
--

