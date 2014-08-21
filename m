Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbaHUFUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 01:20:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35472 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaHUFU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 01:20:28 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-ef-53f581936492
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>, "'Felipe Balbi'" <balbi@ti.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Kamil Debski'" <k.debski@samsung.com>,
        "'Mark Brown'" <broonie@linaro.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Linux USB Mailing List'" <linux-usb@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com>
 <CAFp+6iG+BoE5O=EBxNOGPGU3Wws26xtQzzVx1HBhQ3R0SafiMw@mail.gmail.com>
In-reply-to: <CAFp+6iG+BoE5O=EBxNOGPGU3Wws26xtQzzVx1HBhQ3R0SafiMw@mail.gmail.com>
Subject: Re: [PATCH 0/5] usb: phy: samsung: remove old USB PHY code
Date: Thu, 21 Aug 2014 14:20:19 +0900
Message-id: <008a01cfbcff$994c98d0$cbe5ca70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+8+Ro7TJupWllkTm+0KKxTf2kIxwABlibQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t8zfd3JjV+DDdbukrDYOGM9q8XB+/UW
	m65fZ7Vou3KQ3eLywkusFj9eX2Cz6F1wlc3iwtMeNouzTW+AErvmsFnMOL+PyWLRslZmBx6P
	O9f2sHn0bVnF6HH8xnYmj8+b5AJYorhsUlJzMstSi/TtErgylh1czFRwnL3iaPsB9gbGd6xd
	jJwcEgImEpe//mGEsMUkLtxbzwZiCwksY5TofykKUzPnWh9QPRdQfDqjxP3HK9ghnN+MEuu2
	9LKDVLEJqEl8+XIYzBYRSJdoXtvCBFLELNDPLNE/6wkjREc/o8SU24uZQao4BYIlbt8/wgRi
	Cws4S/TsegHWzSKgKrH9xhowm1fAVuL976usELagxI/J91hAbGYBdYlJ8xYxQ9jyEpvXvAWy
	OYBuVZd49FcX4ggjiWdvu9ghSkQk9r14B3aDhEArh8Slzf/YIHYJSHybfIgFoldWYtMBZoiX
	JSUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAiJ
	894djLcPWB9iTAZaP5FZSjQ5H5gm8kriDY3NjCxMTUyNjcwtzUgTVhLnTXqYFCQkkJ5Ykpqd
	mlqQWhRfVJqTWnyIkYmDU6oB6ChFx9V8y4/9PsizQvLcl3fyBg+/ix1J98uY/61B0/R8klue
	3Pe4/1ybdk3U7+L+4fK4Z+ZFo8zo6K2iVUfLxOOWVDDmX8kvvlj+ZPMCvimeQjf5Pp5azPBC
	cG7B29YS7n0nhPeJVcw5XLbo2ddA3XVH5seJx3w+kyoftzRomyfL9D+rNzd1K7EUZyQaajEX
	FScCANo4J0UJAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jQd3JjV+DDd41iFhsnLGe1eLg/XqL
	Tdevs1q0XTnIbnF54SVWix+vL7BZ9C64ymZx4WkPm8XZpjdAiV1z2CxmnN/HZLFoWSuzA4/H
	nWt72Dz6tqxi9Dh+YzuTx+dNcgEsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlApykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CesYM5YdXMxUcJy94mj7AfYGxnesXYycHBICJhJzrvVB2WISF+6tZ+ti5OIQEpjOKHH/8Qp2
	COc3o8S6Lb3sIFVsAmoSX74cBrNFBNIlmte2MIEUMQv0M0v0z3rCCNHRzygx5fZiZpAqToFg
	idv3jzCB2MICzhI9u16AdbMIqEpsv7EGzOYVsJV4//sqK4QtKPFj8j0WEJtZQF1i0rxFzBC2
	vMTmNW+BbA6gW9UlHv3VhTjCSOLZ2y52iBIRiX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWM
	oqkFyQXFSem5RnrFibnFpXnpesn5uZsYwWnkmfQOxlUNFocYBTgYlXh4JdS+BguxJpYVV+Ye
	YpTgYFYS4XX99SVYiDclsbIqtSg/vqg0J7X4EKMp0KMTmaVEk/OBKS6vJN7Q2MTMyNLIzMLI
	xNxcSZz3YKt1oJBAemJJanZqakFqEUwfEwenVAMjo12hwf5r01WdjCcx/XLaEb/+13Hhh10p
	0wUOsf3SdP3w/Lr0vS8XFPVdC5s3FMme2PBgW0r4Y7Vz7jlbZ4StujfbIu9x0lHlyGi3GIYi
	efPKuE0Runt4Vd494nEV2PyHN/pjbY5Hz5/J+/cyVJybMWV/sVdLxIJ7p98s/Jpwfi/fovyC
	KUe2KbEUZyQaajEXFScCAG8m7q05AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 21, 2014 1:34 PM, Vivek Gautam wrote:
> On Thu, Aug 14, 2014 at 7:55 PM, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
> > Hi,
> >
> > This patch series removes the old Samsung USB PHY drivers that
> > got replaced by the new ones using the generic PHY layer.
> >
> > Depends on:
> > - next-20140813 branch of linux-next kernel
> >
> > Best regards,
> > --
> > Bartlomiej Zolnierkiewicz
> > Samsung R&D Institute Poland
> > Samsung Electronics
> >
> >
> > Bartlomiej Zolnierkiewicz (5):
> >   ARM: dts: remove old USB2 PHY node hook for Arndale
> >   ARM: dts: remove old USB2 PHY node for Exynos5250
> >   usb: phy: samsung: remove old USB 2.0 PHY driver
> >   usb: phy: samsung: remove old USB 3.0 PHY driver
> >   usb: phy: samsung: remove old common USB PHY code
> 
> Reviewed-by: Vivek Gautam <gautam.vivek@samsung.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

