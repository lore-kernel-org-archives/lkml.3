Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaEHLiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 07:38:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17550 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaEHLiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 07:38:22 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7fcd6d0000026e0-bc-536b6cacb064
Content-transfer-encoding: 8BIT
Message-id: <536B6CAC.1040805@samsung.com>
Date: Thu, 08 May 2014 20:38:20 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Paul <seanpaul@chromium.org>,
        =?UTF-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marcheu@chromium.org>
Subject: Re: [PATCH 2/4] drm/exynos/mixer: use MXR_GRP_SXY_SY
References: <1399217181-26442-1-git-send-email-djkurtz@chromium.org>
 <1399217181-26442-3-git-send-email-djkurtz@chromium.org>
 <5369C13C.3080506@samsung.com>
 <CAGS+omAbuzRpNDvB6eTw67Dcv3WMdWF3yz+bU5p3j5JRourOyw@mail.gmail.com>
 <536B0900.10204@samsung.com>
 <CAGS+omB8iO2ioLcQEtxsww9kA4Yc8-8YaAkWwTy2ssLOqQvLZg@mail.gmail.com>
In-reply-to: <CAGS+omB8iO2ioLcQEtxsww9kA4Yc8-8YaAkWwTy2ssLOqQvLZg@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWyRsSkQHdNTnawwas7xha9504yWTTOmM9q
	ceXrezaLF/cuslj0LrjKZnG26Q27xabH11gtLu+aw2Yx4/w+Jot5h34zWtzdcJbRYsbkl2wO
	PB6zGy6yeGz/9oDV4373cSaPzUvqPfq2rGL0+LxJLoAtissmJTUnsyy1SN8ugSvj8lfdgm7d
	ih1/DrI2ME5X7mLk5JAQMJHovvSCBcIWk7hwbz0biC0ksJRR4s4COZia3U3dQDVcQPHpjBIz
	T/9gB0nwCghK/Jh8DyjBwcEsIC9x5FI2SJhZQF1i0rxFzBD1rxglmi62M0HUa0nc/rMDzGYR
	UJX49Ww92Bw2IHviivtgi0UFwiRevNrFDDJTBGjQrxtOIHOYBVaxSOyduJoZpEZYwFaiu+0F
	O8SCs0wSN9rmsYIkOAWCJf5cOwyWkBBo5JCYcfw8G8Q2AYlvkw+BXSohICux6QAzxGeSEgdX
	3GCZwCg2C8k/sxD+mYXknwWMzKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxAqP19L9nE3Yw
	3jtgfYgxGWjjRGYp0eR8YLTnlcQbGpsZWZiamBobmVuakSasJM6r9igpSEggPbEkNTs1tSC1
	KL6oNCe1+BAjEwenVAPjWie56ef05kyaIroo4LD4i2czTkV1MyutC37338/YvXLC4gX95/+E
	x8xQjn94s+i5Tt7thS9P7flvs+Yo91KVY1PZHFpav61xcbbats9qzWm2O5H7X/6XfGmx5a2X
	05Suplbe8KoOo1UPJ/Ba7g78fEBjmdzmNSu4rE8GaYfxLLNrXu8fwJfyQYmlOCPRUIu5qDgR
	AJ/gjkXsAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jQd01OdnBBuevaVr0njvJZNE4Yz6r
	xZWv79ksXty7yGLRu+Aqm8XZpjfsFpseX2O1uLxrDpvFjPP7mCzmHfrNaHF3w1lGixmTX7I5
	8HjMbrjI4rH92wNWj/vdx5k8Ni+p9+jbsorR4/MmuQC2qAZGm4zUxJTUIoXUvOT8lMy8dFsl
	7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygI5UUyhJzSoFCAYnFxUr6dpgmhIa46VrA
	NEbo+oYEwfUYGaCBhDWMGZe/6hZ061bs+HOQtYFxunIXIyeHhICJxO6mbhYIW0ziwr31bF2M
	XBxCAtMZJWae/sEOkuAVEJT4MfkeUBEHB7OAvMSRS9kgYWYBdYlJ8xYxQ9S/YpRoutjOBFGv
	JXH7zw4wm0VAVeLXs/Vgc9iA7Ikr7rOB2KICYRIvXu1iBpkpAjTo1w0nkDnMAqtYJPZOXM0M
	UiMsYCvR3faCHWLBWSaJG23zWEESnALBEn+uHWafwCgwC8l9sxDum4XkvgWMzKsYRVMLkguK
	k9JzjfSKE3OLS/PS9ZLzczcxgpPBM+kdjKsaLA4xCnAwKvHwZjhnBQuxJpYVV+YeYpTgYFYS
	4fXKzg4W4k1JrKxKLcqPLyrNSS0+xJgM9N1EZinR5HxgosoriTc0NjEzsjQyN7QwMjYnTVhJ
	nPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsZUU5P3LLcUPJO0H+YJyyxaZu7JOz2J6WHAHnYj
	E+cnZb1WbvsLGfgCT9vGnN3FuDF/3cJgh7kN+gLnf2Xt/KPhqNJtvGJzmY+GK8cDq433XcVv
	bmQM0dTK+PV7j5LRvFtnHGzt1OfO8Z92wXjm5LM6T27sCflUEnvMRP6XybwZU/avmFp4olSJ
	pTgj0VCLuag4EQBRpCZkSgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 2014년 05월 08일 18:21, Daniel Kurtz wrote:
> On Thu, May 8, 2014 at 12:33 PM, Seung-Woo Kim <sw0312.kim@samsung.com> wrote:
>>
>> Hello Daniel,
>>
>> On 2014년 05월 07일 23:14, Daniel Kurtz wrote:
>>> On Wed, May 7, 2014 at 1:14 PM, Seung-Woo Kim <sw0312.kim@samsung.com> wrote:
>>>> Hi Daniel,
>>>>
>>>> On 2014년 05월 05일 00:26, Daniel Kurtz wrote:
>>>>> Mixer hardware supports offsetting dma from start of source buffer using
>>>>> the MXR_GRP_SXY register.
>>>>>
>>>>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>>>>> ---
>>>>>  drivers/gpu/drm/exynos/exynos_mixer.c | 8 +++-----
>>>>>  1 file changed, 3 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
>>>>> index 475eb49..40cf39b 100644
>>>>> --- a/drivers/gpu/drm/exynos/exynos_mixer.c
>>>>> +++ b/drivers/gpu/drm/exynos/exynos_mixer.c
>>>>> @@ -529,13 +529,11 @@ static void mixer_graph_buffer(struct mixer_context *ctx, int win)
>>>>>
>>>>>       dst_x_offset = win_data->crtc_x;
>>>>>       dst_y_offset = win_data->crtc_y;
>>>>> +     src_x_offset = win_data->fb_x;
>>>>> +     src_y_offset = win_data->fb_y;
>>>>>
>>>>>       /* converting dma address base and source offset */
>>>>> -     dma_addr = win_data->dma_addr
>>>>> -             + (win_data->fb_x * win_data->bpp >> 3)
>>>>> -             + (win_data->fb_y * win_data->fb_width * win_data->bpp >> 3);
>>>>> -     src_x_offset = 0;
>>>>> -     src_y_offset = 0;
>>>>> +     dma_addr = win_data->dma_addr;
>>>>
>>>> Basically, you are right and source offset register can be used. But
>>>> because of limitation of resolution for mixer up to 1920x1080, I
>>>> considered modified soruce dma address to set one frame buffer, which is
>>>> bigger than 1920x1080, on to both fimd and hdmi.
>>>
>>> Hi Seung-Woo,
>>>
>>> I do not see why the maximum MIXER resolution matters for choosing
>>> between offsetting BASE or using SXY.
>>>
>>> Let's say you have one big 1920x1908 framebuffer, with a span of 1920,
>>> starting at dma_addr (there is no extra padding at the end of the
>>> line).
>>> Let's say you wanted the mixer to scan out 1920x1080 pixels starting
>>> from (0, 800) in the framebuffer, and start drawing them at (0,0) on
>>> the screen.
>>>
>>> What we currently do is:
>>>   BASE = dma_addr + (800 * 1080 * 4)
>>>   SPAN = 1920
>>>   SXY = SX(0) | SY(0)
>>>   WH = W(1920) | H(1080)
>>>   DXY = DX(0) | DY(0)
>>>
>>> I am proposing we do:
>>>   BASE = dma_addr
>>>   SPAN = 1920
>>>   SXY = SX(0) | SY(800)
>>>   WH = W(1920) | H(1080)
>>>   DXY = DX(0) | DY(0)
>>>
>>> In both cases, the mixer resolution is 1920x1080.
>>
>> In my test to show each half of big one framebuffer (3840 x 1080) to
>> FIMD from 0 to 1079 and MIXER from 1080 to 3839 with exynos4210 and
>> exynos4412, it was failed to show proper hdmi display. Also it is same
>> for framebuffer (1920 x 2160). AFAIK, it is mainly because mixer dma has
>> limitation of dma memory size.
> 
> 
> That is unfortunate, but thank you for your explanation.
> 
> Is this limitation exynos4 specific, or does it also apply for the
> exynos5 mixer?

It seems that exynos5260/5420 mixers also have same limitation: SX/Y
fields is 11 bits.

> Was the limitation perhaps the number of bits in the SXY register
> fields (< 11) on those devices?
> For 5250/5420 these fields are 11 bits, and I don't see any
> restrictions about "dma memory size" in the documentation that I have.
> 

So I guess that the reason Mixer controller was operated incorrectly is
that SX/Y fields exceed maximum value (2047) by itself when he
calculates DMA address to access the memory region: the value of SX/Y
fields would be increased by Mixer controller internally until reaching
width or height, and in turn the value would exceed 2047.

So I think it'd better to use existing codes because this patch isn't
tested so not safe. You can add more comments enough to existing codes
if needed.

In addition, it seems that Exynos5422/5430 has no such limitation but
they are much different from old ones so we would need new drivers for them.

Thanks,
Inki Dae

> Thanks,
> -Dan
> 
>> In this case, I set register as like:
>>   BASE = dma_addr /* 3840 x 1080 x 4 */
>>   SPAN = 3840
>>   SXY = SX(1920) | SY(0)
>>   WH = W(1920) | H(1080)
>>   DXY = DX(0) | DY(0)
>> or:
>>   BASE = dma_addr /* 1920 x 2160 x 4 */
>>   SPAN = 1920
>>   SXY = SX(0) | SY(1080)
>>   WH = W(1920) | H(1080)
>>   DXY = DX(0) | DY(0)
>> but these two setting did not show hdmi display as I expected. So I used
>> modified dma address.
>>
>>>
>>> My motivation for wanting to program an un-modified dma_addr into BASE
>>> is so we can then just check BASE_S to determine from which buffer the
>>> mixer is actively being scanned out without worrying about the source
>>> offset, since the source offset can change for a given framebuffer
>>> (for example, when doing panning, or if an overlay is used for a HW
>>> cursor).
>>
>> Actually, this patch is exactly same with my first implementation, so I
>> completely understand your motivation. Anyway, I was focus on extended
>> displays with one buffer, so I wrote modified dma base address.
>>
>> Thanks and Regards,
>> - Seung-Woo Kim
>>
>>>
>>> Best Regards,
>>> -Daniel
>>>
>>>>
>>>> Regards,
>>>> - Seung-Woo Kim
>>>>
>>>>>
>>>>>       if (win_data->scan_flags & DRM_MODE_FLAG_INTERLACE)
>>>>>               ctx->interlace = true;
>>>>>
>>>>
>>>> --
>>>> Seung-Woo Kim
>>>> Samsung Software R&D Center
>>>> --
>>>>
>>>
>>
>> --
>> Seung-Woo Kim
>> Samsung Software R&D Center
>> --
>>
> 

