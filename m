Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab3ENMIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:08:00 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:64756 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956Ab3ENMH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:07:58 -0400
MIME-Version: 1.0
In-Reply-To: <1368123170-22906-1-git-send-email-dianders@chromium.org>
References: <1368039168-24447-1-git-send-email-dianders@chromium.org>
	<1368123170-22906-1-git-send-email-dianders@chromium.org>
Date: Tue, 14 May 2013 14:07:58 +0200
Message-ID: <CACRpkdZ3grCyf3x5dEbT6hAVDkpM3mwibVO5kT0Lv=a09-zBPA@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: exynos: Select PINCTRL_EXYNOS for exynos4/5 at
 chip level
From: Linus Walleij <linus.walleij@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 8:12 PM, Doug Anderson <dianders@chromium.org> wrote:

> Previously if you had MACH_EXYNOS5_DT but not MACH_EXYNOS4_DT you'd be
> missing the pincontrol definitions.  Move PINCTRL selects to the arch
> level since we should be enabling the code for all exynos variants.
>
> Update the PINCTRL descriptions to indicate that PINCTRL_EXYNOS is not
> for exynos5440.  Also add basic dependencies for the PINCTRL_EXYNOS
> kernel config.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v3:
> - Moved to chip level as per Tomasz.
> - Update PINCTRL Kconfig for exynos.
>
> Changes in v2:
> - Moved to the arch level as suggested by Olof.

Acked-by: Linus Walleij <linus.walleij@linaro.org> for the pinctrl
part, I guess this will be merged through the Samsung tree?

Yours,
Linus Walleij
