Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3BVLQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 06:16:54 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43053 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3BVLQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 06:16:51 -0500
X-AuditID: cbfee68e-b7fc26d000001938-f2-512753a1a809
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Dongjin Kim'" <tobetter@gmail.com>
Cc: "'Alim Akhtar'" <alim.akhtar@gmail.com>,
        "'unlisted-recipients:'"@samsung.com,
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
 <003401ce1021$ab1b6eb0$01524c10$%jun@samsung.com>
 <CADoNuNfDuz+njsn+7isNKf-Ud_nNEKFYYf7Xio3=94hVU6KGVA@mail.gmail.com>
In-reply-to: <CADoNuNfDuz+njsn+7isNKf-Ud_nNEKFYYf7Xio3=94hVU6KGVA@mail.gmail.com>
Subject: RE: [PATCH v3] mmc: dw_mmc: Add MSHC compatible for Exynos4412
Date: Fri, 22 Feb 2013 20:16:48 +0900
Message-id: <001001ce10ee$1b962a50$52c27ef0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QnYLCaVb917F7SGiWkHiMqOl54gABFF2w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zQ92FweqBBpuPy1pc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLO3+EouGlSMf/wNpYGxg8aXYycHBICJhLXph1ngbDF
	JC7cW8/WxcjFISSwjFHi8dXfjDBFjY2XoRLTGSV6Py9lh3D+MEos2vuTDaSKTUBL4u+bN8wg
	toiAmkTj305WkCJmgX9MEhfeLGCC6ABy7v54CtbBKRAssXTVLyYQW1jAXeLdltmsIDaLgKrE
	5K2/wCbxCthKHD7+iBXCFpT4Mfke0LEcQFP1JO5f1AIJMwvIS2xe85YZJCwhoC7x6K8uxA1G
	Et+/P2GHKBGR2PfiHSPICRICq9glXvZchlolIPFt8iEWiF5ZiU0HmCE+lpQ4uOIGywRGiVlI
	Fs9CWDwLyeJZSDYsYGRZxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iRESY307GG8esD7EmAy0
	fSKzlGhyPjBG80riDY2NTcxMTE3MLU3NTUkTVhLnlb8kEygkkJ5YkpqdmlqQWhRfVJqTWnyI
	kYmDU6qBsfLBVfaMKcVrEly+esaIpt1b+yu4y89/YirXv3g7be5je//H7WFr7J0oflVO17X7
	6lshQ19hD3lmR9lvdg0vl+rqbLQzmnbgc6686h+XdcLKdXEOFVUThO2+hXzpYfZSqJ9mJSRj
	MSHMSmZJ2vx3vD1r2LakaVcWCCT4pZxyLrvDvOLL0xdKLMUZiYZazEXFiQACRNb6xwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jQd2FweqBBh8miVtc3jWHzeLI/35G
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzzt/hKLhpUjH/
	8DaWBsYPGl2MnBwSAiYSjY2X2SBsMYkL99YD2VwcQgLTGSV6Py9lh3D+MEos2vsTrIpNQEvi
	75s3zCC2iICaROPfTlaQImaBf0wSF94sYILoAHLu/ngK1sEpECyxdNUvJhBbWMBd4t2W2awg
	NouAqsTkrb/AJvEK2EocPv6IFcIWlPgx+R5LFyMH0FQ9ifsXtUDCzALyEpvXvGUGCUsIqEs8
	+qsLcYORxPfvT9ghSkQk9r14xziBUWgWkkGzEAbNQjJoFpKOBYwsqxhFUwuSC4qT0nMN9YoT
	c4tL89L1kvNzNzGCI/iZ1A7GlQ0WhxgFOBiVeHgbXNQChVgTy4orcw8xSnAwK4nwGlioBwrx
	piRWVqUW5ccXleakFh9iTAZ6cyKzlGhyPjC55JXEGxqbmBlZGplZGJmYm5MmrCTOy3jqSYCQ
	QHpiSWp2ampBahHMFiYOTqkGRp5/Tn5NphM3LNvzU7FGu+gal472arn7JcybGnbXNEZe3/Uw
	f41u0uTVbv61Ig5b0qLvyHldZpzrKTjpIb9e3PWgu7JhzV/zI8Mnav1o51x+/Zx5nusJLXOe
	5yatjrfPTTh3IepRZ8SkK83vwntmxbdIe1e9lI3afnd6QAPb5G+v+isnyTSwK7EUZyQaajEX
	FScCAGyIO5gkAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 22, 2013, Dongjin Kim wrote:
> Hello Seungwon,
> 
> OK, I will change the commit message. And I also think Alim's idea is
> good but need more detail about functional features of Synopsis' IP.
Yes, Alim gave good suggestions.
 It would be useful. But I think it's close to platform rather than Synopsys itself.
 I'm starting to compare the new generic parsing with dw_mmc.
> Similar situation would be happened to Exynos4210 which is not
> supported by dw_mmc-exynos.c yet.
Maybe not, it should be done.

Thanks,
Seungwon Jeon
> 
> Regards,
> Dongjin.
> 
> On Thu, Feb 21, 2013 at 7:53 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> > On Wednesday, February 20, 2013, Alim Akhtar wrote:
> >> Hi,
> >>
> >> On Tue, Feb 19, 2013 at 6:04 PM, Dongjin Kim <tobetter@gmail.com> wrote:
> >> > Hello Seungwon,
> >> >
> >> > Thank you for reviewing and I understand what you mean.
> >> >
> >> > I agree that Exynos5250 and Exynos4412 are not same, no idea how much
> >> > they are different because no Exynos5250 spec on my hand. But at least
> >> > I assumed that the capabilities below are supported by Exynos4412 in
> >> > terms of its datasheet and it does work on my end as expected. :) Also
> >> > I assumed it will be separated if one of both become different to add
> >> > more capabilities.
> >> >
> >> >         MMC_CAP_UHS_DDR50 | MMC_CAP_1_8V_DDR |
> >> >                MMC_CAP_8_BIT_DATA | MMC_CAP_CMD23,
> >> >
> >> > Maybe my understanding or approach is wrong since I do not have the
> >> > information of Exynos5250.
> >> > And suggestion do you have?
> > At least, these capabilities can be shared because of common feature, not fully same.
> > Dongjin, could you modify the commit message and comments of code?
> >
> > Let me introduce the functional feature of Exynos5250 and capability extension.
> > I guess I'll send soon.
> >
> > Thanks,
> > Seungwon Jeon
> >
> >>
> >> Recently Guennadi Liakhovetski has done some work to centralize the
> >> mmc capabilities. See [1] and [2].
> >> Those patches are pushed to Chris's mmc-next tree.
> >> Is  it possible to extend [1] and [2] and add more capabilities (at
> >> least all known one) and let these caps being passed from DT instead?
> >>
> >> Second thought is, let the common minimum caps as a part of .caps
> >> field in dw_mmc-exynos.c itself and pass the extra/advance controller
> >> caps from DT and parse them via dw_mci_parse_dt() in dw_mmc.c itself.
> >>
> >> [1] https://patchwork.kernel.org/patch/1991851/
> >> [2] https://patchwork.kernel.org/patch/2106531/
> >>
> >> > Regards,
> >> > Dongjin.
> >> >
> >> > On Tue, Feb 19, 2013 at 7:19 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> >> >> On Tuesday, February 19, 2013, Dongjin Kim wrote:
> >> >>> This patch adds the compatible string for MSHC controller of Exynos4412, and
> >> >>> share the controller specific properties with Exynos5250 since they have same
> >> >>> features. Its driver data name is changed to exynos_drv_data instead SoC
> >> >>> specific name.
> >> >>
> >> >> It's not actually same.
> >> >> Exynos4412 doesn't have forward compatibilities for Exynos5250.
> >> >> I agree that functionality of exynos_drv_data is common.
> >> >> These functions have been implemented for existing Exynos*.
> >> >> But in case of caps, it can't applied completely.
> >> >> I'm concerning about this.
> >> >>
> >> >> Thanks,
> >> >> Seungwon Jeon
> >> >>>
> >> >>> Cc: Jaehoon Chung <jh80.chung@samsung.com>
> >> >>> Cc: Sachin Kamat <sachin.kamat@linaro.org>
> >> >>> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> >> >>> ---
> >> >>>  drivers/mmc/host/dw_mmc-exynos.c |   12 +++++++-----
> >> >>>  1 file changed, 7 insertions(+), 5 deletions(-)
> >> >>>
> >> >>> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
> >> >>> index 4d50da6..38cd03c 100644
> >> >>> --- a/drivers/mmc/host/dw_mmc-exynos.c
> >> >>> +++ b/drivers/mmc/host/dw_mmc-exynos.c
> >> >>> @@ -199,8 +199,8 @@ static int dw_mci_exynos_setup_bus(struct dw_mci *host,
> >> >>>       return 0;
> >> >>>  }
> >> >>>
> >> >>> -/* Exynos5250 controller specific capabilities */
> >> >>> -static unsigned long exynos5250_dwmmc_caps[4] = {
> >> >>> +/* Exynos4412/Exynos5250 controller specific capabilities */
> >> >>> +static unsigned long exynos_dwmmc_caps[4] = {
> >> >>>       MMC_CAP_UHS_DDR50 | MMC_CAP_1_8V_DDR |
> >> >>>               MMC_CAP_8_BIT_DATA | MMC_CAP_CMD23,
> >> >>>       MMC_CAP_CMD23,
> >> >>> @@ -208,8 +208,8 @@ static unsigned long exynos5250_dwmmc_caps[4] = {
> >> >>>       MMC_CAP_CMD23,
> >> >>>  };
> >> >>>
> >> >>> -static const struct dw_mci_drv_data exynos5250_drv_data = {
> >> >>> -     .caps                   = exynos5250_dwmmc_caps,
> >> >>> +static const struct dw_mci_drv_data exynos_drv_data = {
> >> >>> +     .caps                   = exynos_dwmmc_caps,
> >> >>>       .init                   = dw_mci_exynos_priv_init,
> >> >>>       .setup_clock            = dw_mci_exynos_setup_clock,
> >> >>>       .prepare_command        = dw_mci_exynos_prepare_command,
> >> >>> @@ -219,8 +219,10 @@ static const struct dw_mci_drv_data exynos5250_drv_data = {
> >> >>>  };
> >> >>>
> >> >>>  static const struct of_device_id dw_mci_exynos_match[] = {
> >> >>> +     { .compatible = "samsung,exynos4412-dw-mshc",
> >> >>> +                     .data = &exynos_drv_data, },
> >> >>>       { .compatible = "samsung,exynos5250-dw-mshc",
> >> >>> -                     .data = &exynos5250_drv_data, },
> >> >>> +                     .data = &exynos_drv_data, },
> >> >>>       {},
> >> >>>  };
> >> >>>  MODULE_DEVICE_TABLE(of, dw_mci_exynos_match);
> >> >>> --
> >> >>> 1.7.10.4
> >> >>>
> >> >>> --
> >> >>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> >> >>> the body of a message to majordomo@vger.kernel.org
> >> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >>
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >> --
> >> Regards,
> >> Alim
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

