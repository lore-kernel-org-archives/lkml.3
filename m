Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab3JYJ3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 05:29:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:50978 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab3JYJ3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 05:29:11 -0400
X-AuditID: cbfee68e-b7f416d0000020d6-96-526a39e5b67a
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
In-reply-to: <CAD=FV=WL0K4qiRGsQxG7vfp41dV9fp=7d6d6i5qomJd7jbLEPg@mail.gmail.com>
Subject: RE: [PATCH 1/2] mmc: dw_mmc: Cleanup disable of low power mode w/ SDIO
 interrupts
Date: Fri, 25 Oct 2013 18:29:08 +0900
Message-id: <000f01ced164$a8181b50$f84851f0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7QiqOmSv58LeMCTBKMpGSZ86wgaQAmwzDQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t8zQ92nlllBBk83Sls8XrOYyeLBvG1s
	FvO2HmW12P56I5vF2WUH2SxeHfnBZPFu3gtmixu/2lgtLu+aw2Zx5H8/o8Wp65/ZLJ6cmclo
	sWrXH0YHXo/ZDRdZPHbOusvu0bPzDKPHoStrGT2unGhi9Zi88CKzR9+WVYwenzfJBXBEcdmk
	pOZklqUW6dslcGU8+3SXveCxaMW7uwtZGhi3C3YxcnJICJhIvHw4kwXCFpO4cG89WxcjF4eQ
	wDJGiWNnrzLBFF189ZMVIjGdUaJ58k52COcPo8Sf1ouMIFVsAloSf9+8YQaxRQS0JV4+WMkM
	UsQscJJZovPhD6i5T5gkFu84CNbBKRAscXffJ7AdwgIxEt8vPAaLswioSsy/ehwszitgK3F6
	1zIWCFtQ4sfke2A2s4CexMc/txkhbHmJzWveAm3jALpVXeLRX12II4wktmyYAFUiIrHvxTtG
	kBskBNZySLz7M4sFYpeAxLfJh1ggemUlNh1ghnhZUuLgihssExglZiHZPAvJ5llINs9CsmIB
	I8sqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjJDk0LeD8eYB60OMyUDrJzJLiSbnA5NLXkm8
	obGZkYWpiamxkbmlGWnCSuK8ix4mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpgFDYNlWDN
	jVu57XfC4RV/zdjE36VMYD0ol9FaNv+Nj5yv3h8ztpZtMQEyix2DvkgFlTzbrM1SN+vfRMN0
	JilO+bCF5oWb2Gdp/RYzXectG3PslTtfnZ/AH9YsBo6AbT9DIrU5ve/btibcl9Ner+v9bff5
	LZ1eje90wgKdtbUfcEV4F2rOmKHEUpyRaKjFXFScCADL75v0JAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHKsWRmVeSWpSXmKPExsVy+t9jQd2nlllBBq8Wilo8XrOYyeLBvG1s
	FvO2HmW12P56I5vF2WUH2SxeHfnBZPFu3gtmixu/2lgtLu+aw2Zx5H8/o8Wp65/ZLJ6cmclo
	sWrXH0YHXo/ZDRdZPHbOusvu0bPzDKPHoStrGT2unGhi9Zi88CKzR9+WVYwenzfJBXBENTDa
	ZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdraRQlphT
	ChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMePbpLnvBY9GKd3cXsjQwbhfsYuTk
	kBAwkbj46icrhC0mceHeerYuRi4OIYHpjBLNk3eyQzh/GCX+tF5kBKliE9CS+PvmDTOILSKg
	LfHywUpmkCJmgZPMEp0Pf0C1P2GSWLzjIFgHp0CwxN19n5hAbGGBGInvFx6DxVkEVCXmXz0O
	FucVsJU4vWsZC4QtKPFj8j0wm1lAT+Ljn9uMELa8xOY1b4G2cQDdqi7x6K8uxBFGEls2TIAq
	EZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGc
	ep5J72Bc1WBxiFGAg1GJhzdhRmaQEGtiWXFl7iFGCQ5mJRFeFaOsICHelMTKqtSi/Pii0pzU
	4kOMyUCPTmSWEk3OB6bFvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFs
	YeLglGpgbHpy/3hXjNr1JNulolcENGrfc5VV2TUd8gu6Eyos+2mByoNJTIw7FizQDDU7aXxZ
	baGh2+tm08lTVmZK1bLGSKY1TrWIcj375TNT65IZJysM921eZDOx+dkFT+u8BQubZLV/H7oR
	JsCwzOyR7AMzlcuW6gwRphNaww++ubku+yGDW+wzh4BjSizFGYmGWsxFxYkAKT+YyYEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, October 24, 2013, Doug Anderson wrote:
> Seungwon,
> 
> On Wed, Oct 23, 2013 at 12:25 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> >> >> +             if (card->type == MMC_TYPE_SDIO ||
> >> >> +                 card->type == MMC_TYPE_SD_COMBO) {
> > && card->quirks & MMC_QUIRK_BROKEN_CLK_GATING
> > How about considering MMC_QUIRK_BROKEN_CLK_GATING?
> > Some sdio device can work with gating clock.
> > For this, mmc_fixup_device() should be called prior to init_card() in core(sdio.c).
> > I guess you found that.
> 
> By SDIO devices, are you referring to actual SDIO cards or some
> implementations of dw_mmc?
> 
> As far as I understand in the CLKENA description in the generic
> documentation from Synopsys it say that for SDIO cards you must not
> stop the clock if interrupts must be detected.  To me, that means that
> all dw_mmc implementations require this change if they support SDIO
> interrupts (hence checking for MMC_CAP_SDIO_IRQ).

CLKENA description in manual means that host controller can't detect the SDIO interrupt signal
or wifi device can't generate the interrupt without clock?
Host controller based on Synopsys supports asynchronous interrupts. It seems to depend on wifi Device.
If host can do and  wifi device can also work with clock gating, we may enable low-power mode.

For MMC_QUIRK_BROKEN_CLK_GATING, I referred the code in 'mmc/core/quirks.c'
In addition, although host can support MMC_CAP_SDIO_IRQ, some wifi drivers use
OOB(Out-of-band) interrupt. That means host can apply clock gating to reduce
power consumption.

Thanks,
Seungwon Jeon

> 
> I guess I did make the assumption in this change that all (reasonable)
> SDIO cards would be using SDIO interrupts if they are available.  If
> we could find out ahead of time if a given SDIO driver was planning to
> use interrupts we could do better.  The old solution did better in
> this way and we could probably make it work (and still fix the
> read-modify-write race) if we thought this was really important.  The
> code gets a little more twisted to try to avoid holding the IRQ-safe
> spinlock while updating the clock, but I could attempt it...
> 
> 
> NOTE: We've recently found that there are still occasions when we lose
> SDIO interrupts with dw_mmc and our Marvell WiFi driver, especially
> when those interrupts happen back-to-back.  That problem appears
> unrelated to this one (it's what Bing was investigating when he found
> the original race).  Anyone that has any thoughts, please let me
> know...
> 
> -Doug
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

