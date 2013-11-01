Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab3KAFXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 01:23:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45368 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3KAFXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 01:23:31 -0400
X-AuditID: cbfee690-b7f3d6d000001c4a-fe-52733ad2ef07
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Sonny Rao'" <sonnyrao@chromium.org>,
        "'Bing Zhao'" <bzhao@marvell.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1381876762-10892-1-git-send-email-dianders@chromium.org>
 <1381876762-10892-2-git-send-email-dianders@chromium.org>
 <52610273.3080005@samsung.com>
 <CAD=FV=UiUxoqbAeq+3iUChqksHd_NpJs2rM83=ng3fprMj0E-A@mail.gmail.com>
 <001701cecfe2$9831eb90$c895c2b0$%jun@samsung.com>
 <CAD=FV=WL0K4qiRGsQxG7vfp41dV9fp=7d6d6i5qomJd7jbLEPg@mail.gmail.com>
 <000f01ced164$a8181b50$f84851f0$%jun@samsung.com>
 <CAD=FV=VLNdNMg2gAj7yUs2ZgP0GqO5SOQLARq+p1qQTGwFDsQQ@mail.gmail.com>
In-reply-to: <CAD=FV=VLNdNMg2gAj7yUs2ZgP0GqO5SOQLARq+p1qQTGwFDsQQ@mail.gmail.com>
Subject: RE: [PATCH 1/2] mmc: dw_mmc: Cleanup disable of low power mode w/ SDIO
 interrupts
Date: Fri, 01 Nov 2013 14:23:29 +0900
Message-id: <001301ced6c2$7fe533d0$7faf9b70$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7ULqOu5C1SjbZPSDmB/X9UNWrwYwBzFFIA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t8zI91LVsVBBj//sVg8XrOYyeLBvG1s
	FvO2HmW12P56I5vF2WUH2SxeHfnBZPFu3gtmixu/2lgtLu+aw2Zx5H8/o8Wp65/ZLJ6cmclo
	sWrXH0YHXo/ZDRdZPHbOusvu0bPzDKPHoStrGT2unGhi9Zi88CKzR9+WVYwenzfJBXBEcdmk
	pOZklqUW6dslcGXsfXaLteCLVMWZFckNjNtFuxg5OSQETCRmTj3IDmGLSVy4t56ti5GLQ0hg
	GaPEn2fL2WGKevtmMUIkFjFKHNs6E8r5wyjx71I/K0gVm4CWxN83b5hBbBEBbYmXD1YygxQx
	C5xkluh8+ANq7n1miTcNNxhBqjgFgiUerl8ItkNYIEbi+4XHYHEWAVWJdV8PgE3lFbCVaJ23
	lRHCFpT4MfkeC4jNLKAn8fHPbUYIW15i85q3QNs4gG5Vl3j0VxfiCCOJD8tvMkGUiEjse/EO
	7GoJgS0cEs/fbmOG2CUg8W3yIRaIXlmJTQeYIV6WlDi44gbLBEaJWUg2z0KyeRaSzbOQrFjA
	yLKKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIyQ1TNjBeO+A9SHGZKD1E5mlRJPzgaklryTe
	0NjMyMLUxNTYyNzSjDRhJXFetUdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYhQ7nGpeZ
	OT0XVc76MGXyuSuLZn8OTPD58Vkxt7k1LMvklJesjuifdxbP5xXxVtVMWqLWdvIn27Ff/7Rj
	A1ebLJVWdIx5f/S1TM3LRAumVMcVmSev6y5Z5/p29cIAs//rnh4S3/7QxU++b03Mitez//Wu
	cZ3m/GFCmNnz+tUNKloZ7rGuog+eKbEUZyQaajEXFScCAIBGKTYjAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsVy+t9jAd2LVsVBBjO32Fg8XrOYyeLBvG1s
	FvO2HmW12P56I5vF2WUH2SxeHfnBZPFu3gtmixu/2lgtLu+aw2Zx5H8/o8Wp65/ZLJ6cmclo
	sWrXH0YHXo/ZDRdZPHbOusvu0bPzDKPHoStrGT2unGhi9Zi88CKzR9+WVYwenzfJBXBENTDa
	ZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdraRQlphT
	ChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM2PvsFmvBF6mKMyuSGxi3i3YxcnJI
	CJhI9PbNYoSwxSQu3FvP1sXIxSEksIhR4tjWmYwQzh9GiX+X+llBqtgEtCT+vnnDDGKLCGhL
	vHywkhmkiFngJLNE58MfUO33mSXeNNwAm8spECzxcP1CdhBbWCBG4vuFx2BxFgFViXVfD4BN
	5RWwlWidt5URwhaU+DH5HguIzSygJ/Hxz21GCFteYvOat0DbOIBuVZd49FcX4ggjiQ/LbzJB
	lIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQI
	TjzPpHYwrmywOMQowMGoxMPrMLEoSIg1say4MvcQowQHs5II7w6l4iAh3pTEyqrUovz4otKc
	1OJDjMlAj05klhJNzgcmxbySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbB
	bGHi4JRqYKyafcXcYfasZf9X+borChq9u/CKP2HT00S9sr6CSVJK7AmRz7U/HJmc1Pb0TILt
	jNtZjF8s1Bm/n9DVOih+hinHce/psv/Grlv2Faxa1iL5/MxyPen1SebPU42WrGH8ZCw00dY4
	V8ZHYKPmh83rurQ+b/0u9fvQNHnWazWrVBNO37O5uvBEsLcSS3FGoqEWc1FxIgBUiz/EgAMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, October 29, 2013, Doug Anderson wrote
> Seungwon,
> 
> On Fri, Oct 25, 2013 at 2:29 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> >> By SDIO devices, are you referring to actual SDIO cards or some
> >> implementations of dw_mmc?
> >>
> >> As far as I understand in the CLKENA description in the generic
> >> documentation from Synopsys it say that for SDIO cards you must not
> >> stop the clock if interrupts must be detected.  To me, that means that
> >> all dw_mmc implementations require this change if they support SDIO
> >> interrupts (hence checking for MMC_CAP_SDIO_IRQ).
> >
> > CLKENA description in manual means that host controller can't detect the SDIO interrupt signal
> > or wifi device can't generate the interrupt without clock?
> 
> My reading of the "if interrupts must be detected" in the manual
> implies that that interrupts simply can't be detected by the
> controller.
I just wanted to know your opinion because I was not convinced that.
But, as far as I know, interrupt is generated by device with clock sync.
If clock is stopped, device may not issue interrupt.
This is the reason that interrupt is not detected.
Ok. Anyway, clock should be required for synchronous interrupt.

> 
> 
> > Host controller based on Synopsys supports asynchronous interrupts. It seems to depend on wifi
> Device.
> > If host can do and  wifi device can also work with clock gating, we may enable low-power mode.
> 
> Ah, interesting!  I wish I had known about this earlier and we could
> have actually used it in our designs.  Please correct me if I'm wrong
> but...
> 
> It looks like asynchronous interrupts is when you use a separate INT#
> line for your SDIO interrupts and is available only for eSDIO
> (embedded SDIO?), right.  ...so that means it more a property of the
> board rather than the card itself.  In other words: to use
> asynchronous interrupts you need to be on a SoC that supports the INT#
> line, you need to have it wired up to an eSDIO module, and you need
> the eSDIO card to support it.
Right. But we cannot say without the device which supports INT#.
For asynchronous interrupt, device should be mounted on target board.

> 
> Assuming that I understand all of the above I'd suggest (in a future
> patch) that we add a property like 'dedicated-sdio-irq' to device
> trees.  If we see this property AND we don't see
> MMC_QUIRK_BROKEN_CLK_GATING then we know we don't need to disable
> clock gating.
> 
> Does that sound right?  If so I'd still love to land my patch and we
> could add the extra logic in a separate patch.
Ok. I like it. Will you send it with this series?
If not, existing MMC_QUIRK_BROKEN_CLK_GATING could be considered at this time.
And, could you modify your comment message more definitely?

> 
> 
> > For MMC_QUIRK_BROKEN_CLK_GATING, I referred the code in 'mmc/core/quirks.c'
> > In addition, although host can support MMC_CAP_SDIO_IRQ, some wifi drivers use
> > OOB(Out-of-band) interrupt. That means host can apply clock gating to reduce
> > power consumption.
> 
> I think OOB interrupt is the same as asynchronous interrupt, but if
> I'm wrong please correct me.
Yes. Eventually both mechanisms are asynchronous.
Additionally, OOB I mentioned comes from some wlan driver commit & implementation.
I guess it doesn't indicate OOB of SDIO specification 4.0 and it's not same.

Thanks,
Seungwon Jeon


