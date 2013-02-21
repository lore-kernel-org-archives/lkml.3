Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab3BUKx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 05:53:27 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:38734 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab3BUKxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 05:53:25 -0500
X-AuditID: cbfee690-b7f066d00000169f-9a-5125fca317e7
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Alim Akhtar'" <alim.akhtar@gmail.com>,
        "'Dongjin Kim'" <tobetter@gmail.com>
Cc: "'unlisted-recipients:'"@samsung.com,
        "'no To-header on input'"@samsung.com,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Chris Ball'" <cjb@laptop.org>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Will Newton'" <will.newton@imgtec.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1361210793-5710-1-git-send-email-tobetter@gmail.com>
 <000501ce0e8a$91ef7c30$b5ce7490$%jun@samsung.com>
 <CADoNuNc2cjOU-PjWgwtB2wo9USMABGdwP=udCBHBYO9jgiLnvw@mail.gmail.com>
 <CAGOxZ51YtUL1yOJERLZG7uWgfQ=j88HmYue1oWiuah6Gdr32Eg@mail.gmail.com>
In-reply-to: <CAGOxZ51YtUL1yOJERLZG7uWgfQ=j88HmYue1oWiuah6Gdr32Eg@mail.gmail.com>
Subject: RE: [PATCH v3] mmc: dw_mmc: Add MSHC compatible for Exynos4412
Date: Thu, 21 Feb 2013 19:53:22 +0900
Message-id: <003401ce1021$ab1b6eb0$01524c10$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4OwRjtKpPWUM8RQ8qoqfqzloRccQAixvzg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zA93Ff1QDDXb+k7S4vGsOm8WR//2M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGU09okWPNKqaOi/xdzAuFKxi5GTQ0LARGLGj5+sELaY
	xIV769m6GLk4hASWMUose7SCHaZo9ZxvjBCJRYwSly40QFX9YZRYvGsRWDubgJbE3zdvmEFs
	EQFfialrdrCAFDEL/GOSOD/zHVR7M5PE0q03wKo4BYIl/p6eBWYLC7hLvNsyG2wSi4CqxNJl
	u9hAbF4BW4krnW/YIWxBiR+T7wFN5QCaqidx/6IWSJhZQF5i85q3zCBhCQF1iUd/dSFuMJLY
	8O0SC0SJiMS+FxAnSAisY5d4dfAtM8QqAYlvkw+xQPTKSmw6wAzxsaTEwRU3WCYwSsxCsngW
	wuJZSBbPQrJhASPLKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYyQGJuwg/HeAetDjMlA2ycy
	S4km5wNjNK8k3tDY2MTMxNTE3NLU3JQ0YSVxXvlLMoFCAumJJanZqakFqUXxRaU5qcWHGJk4
	OKUaGAvdjOJ32xZPUK/f7L7K9cq86OWqX9Wi41n39AkbPbWtX3bq8Alra91ZC3rVzVQ61A+s
	q9h3f28Jw1lTs/9TSnnWai4zvDBV6Y+2q8+hVznvfCY+Payqd63vm3H1R8bWC9FXPyx/+G5u
	3yq+73FJzbF84X9aNbYK+gh9OFO4NVT99M6kWybB/EosxRmJhlrMRcWJAFXfjPnHAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd3Ff1QDDTq2iFhc3jWHzeLI/35G
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzGvtECx5pVTT0
	32JuYFyp2MXIySEhYCKxes43RghbTOLCvfVsXYxcHEICixglLl1ogHL+MEos3rWIFaSKTUBL
	4u+bN8wgtoiAr8TUNTtYQIqYBf4xSZyf+Y4RoqOZSWLp1htgVZwCwRJ/T88Cs4UF3CXebZkN
	NolFQFVi6bJdbCA2r4CtxJXON+wQtqDEj8n3gKZyAE3Vk7h/UQskzCwgL7F5zVtmkLCEgLrE
	o7+6EDcYSWz4dokFokREYt+Ld4wTGIVmIRk0C2HQLCSDZiHpWMDIsopRNLUguaA4KT3XUK84
	Mbe4NC9dLzk/dxMjOIKfSe1gXNlgcYhRgINRiYd3wUuVQCHWxLLiytxDjBIczEoivD/fqgYK
	8aYkVlalFuXHF5XmpBYfYkwGenMis5Rocj4wueSVxBsam5gZWRqZWRiZmJuTJqwkzst46kmA
	kEB6YklqdmpqQWoRzBYmDk6pBkaz+Na37r1nvhQuZHfmV3L/NCn0SlSiVSnbnZS3Vw+tvyIX
	k5b0lW8RIxO7/PkrIe/mbDc67bZs1/NFN7kO+v1fdygubpb8hF8POqZ/CmWY8OLhC56JE7W+
	SJbYWvZEm7Dy5S303b/a8eQBbX93ywghVt5Lv+1sX0m927TGbPOFUIYnP0+/1WFQYinOSDTU
	Yi4qTgQAVVWXciQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2013, Alim Akhtar wrote:
> Hi,
> 
> On Tue, Feb 19, 2013 at 6:04 PM, Dongjin Kim <tobetter@gmail.com> wrote:
> > Hello Seungwon,
> >
> > Thank you for reviewing and I understand what you mean.
> >
> > I agree that Exynos5250 and Exynos4412 are not same, no idea how much
> > they are different because no Exynos5250 spec on my hand. But at least
> > I assumed that the capabilities below are supported by Exynos4412 in
> > terms of its datasheet and it does work on my end as expected. :) Also
> > I assumed it will be separated if one of both become different to add
> > more capabilities.
> >
> >         MMC_CAP_UHS_DDR50 | MMC_CAP_1_8V_DDR |
> >                MMC_CAP_8_BIT_DATA | MMC_CAP_CMD23,
> >
> > Maybe my understanding or approach is wrong since I do not have the
> > information of Exynos5250.
> > And suggestion do you have?
At least, these capabilities can be shared because of common feature, not fully same.
Dongjin, could you modify the commit message and comments of code?

Let me introduce the functional feature of Exynos5250 and capability extension.
I guess I'll send soon.

Thanks,
Seungwon Jeon

> 
> Recently Guennadi Liakhovetski has done some work to centralize the
> mmc capabilities. See [1] and [2].
> Those patches are pushed to Chris's mmc-next tree.
> Is  it possible to extend [1] and [2] and add more capabilities (at
> least all known one) and let these caps being passed from DT instead?
> 
> Second thought is, let the common minimum caps as a part of .caps
> field in dw_mmc-exynos.c itself and pass the extra/advance controller
> caps from DT and parse them via dw_mci_parse_dt() in dw_mmc.c itself.
> 
> [1] https://patchwork.kernel.org/patch/1991851/
> [2] https://patchwork.kernel.org/patch/2106531/
> 
> > Regards,
> > Dongjin.
> >
> > On Tue, Feb 19, 2013 at 7:19 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> >> On Tuesday, February 19, 2013, Dongjin Kim wrote:
> >>> This patch adds the compatible string for MSHC controller of Exynos4412, and
> >>> share the controller specific properties with Exynos5250 since they have same
> >>> features. Its driver data name is changed to exynos_drv_data instead SoC
> >>> specific name.
> >>
> >> It's not actually same.
> >> Exynos4412 doesn't have forward compatibilities for Exynos5250.
> >> I agree that functionality of exynos_drv_data is common.
> >> These functions have been implemented for existing Exynos*.
> >> But in case of caps, it can't applied completely.
> >> I'm concerning about this.
> >>
> >> Thanks,
> >> Seungwon Jeon
> >>>
> >>> Cc: Jaehoon Chung <jh80.chung@samsung.com>
> >>> Cc: Sachin Kamat <sachin.kamat@linaro.org>
> >>> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> >>> ---
> >>>  drivers/mmc/host/dw_mmc-exynos.c |   12 +++++++-----
> >>>  1 file changed, 7 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
> >>> index 4d50da6..38cd03c 100644
> >>> --- a/drivers/mmc/host/dw_mmc-exynos.c
> >>> +++ b/drivers/mmc/host/dw_mmc-exynos.c
> >>> @@ -199,8 +199,8 @@ static int dw_mci_exynos_setup_bus(struct dw_mci *host,
> >>>       return 0;
> >>>  }
> >>>
> >>> -/* Exynos5250 controller specific capabilities */
> >>> -static unsigned long exynos5250_dwmmc_caps[4] = {
> >>> +/* Exynos4412/Exynos5250 controller specific capabilities */
> >>> +static unsigned long exynos_dwmmc_caps[4] = {
> >>>       MMC_CAP_UHS_DDR50 | MMC_CAP_1_8V_DDR |
> >>>               MMC_CAP_8_BIT_DATA | MMC_CAP_CMD23,
> >>>       MMC_CAP_CMD23,
> >>> @@ -208,8 +208,8 @@ static unsigned long exynos5250_dwmmc_caps[4] = {
> >>>       MMC_CAP_CMD23,
> >>>  };
> >>>
> >>> -static const struct dw_mci_drv_data exynos5250_drv_data = {
> >>> -     .caps                   = exynos5250_dwmmc_caps,
> >>> +static const struct dw_mci_drv_data exynos_drv_data = {
> >>> +     .caps                   = exynos_dwmmc_caps,
> >>>       .init                   = dw_mci_exynos_priv_init,
> >>>       .setup_clock            = dw_mci_exynos_setup_clock,
> >>>       .prepare_command        = dw_mci_exynos_prepare_command,
> >>> @@ -219,8 +219,10 @@ static const struct dw_mci_drv_data exynos5250_drv_data = {
> >>>  };
> >>>
> >>>  static const struct of_device_id dw_mci_exynos_match[] = {
> >>> +     { .compatible = "samsung,exynos4412-dw-mshc",
> >>> +                     .data = &exynos_drv_data, },
> >>>       { .compatible = "samsung,exynos5250-dw-mshc",
> >>> -                     .data = &exynos5250_drv_data, },
> >>> +                     .data = &exynos_drv_data, },
> >>>       {},
> >>>  };
> >>>  MODULE_DEVICE_TABLE(of, dw_mci_exynos_match);
> >>> --
> >>> 1.7.10.4
> >>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> Regards,
> Alim
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

