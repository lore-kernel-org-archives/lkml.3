Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3EISLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 14:11:16 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:41562 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab3EISLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 14:11:11 -0400
MIME-Version: 1.0
In-Reply-To: <1614776.P66h1VoFPp@amdc1227>
References: <1368034349-15091-1-git-send-email-dianders@chromium.org>
	<CAD=FV=X2n+zHZ3frorwW7L1yybnWWK1=-rWMQJQFus3eNiFFeQ@mail.gmail.com>
	<CAOesGMi=K4iJKjSk3RoynhiCMPPT98v5jADnqZ__TwX_YLw65Q@mail.gmail.com>
	<1614776.P66h1VoFPp@amdc1227>
Date: Thu, 9 May 2013 11:11:10 -0700
X-Google-Sender-Auth: yx7Lc4MFkmxObUtNV-y2hf_46Aw
Message-ID: <CAD=FV=X1XL++O43GBcJK5Js=ci8pfoj=uSADMcqq_jGJEvhXdQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: exynos: Select PINCTRL_EXYNOS for exynos5
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Olof Johansson <olof@lixom.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Simon Glass <sjg@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz / Olof,

On Thu, May 9, 2013 at 2:45 AM, Tomasz Figa <t.figa@samsung.com> wrote:
>> Nothing stops you from doing that on your own. I tend to push back
>> onto the maintainers to get them engaged in their own housekeeping,
>> but anyone is free to :)

I will probably leave this to the maintainers at this point...  ;)

>> Yeah, it should -- this is just in transition since 5440 was first out
>> of the gate with pinctrl.
>
> AFAIK, Exynos5440 contains a completely different pin controller block, which
> is not compatible with pinctrl-samsung driver, so I don't see any point of
> moving it under PINCTRL_EXYNOS, which is currently used for Exynos 4210, 4x12
> and 5250, but will be also extended with driver data for S5PV210 as well.
>
> I'd say that CPU_EXYNOS4210, SOC_EXYNOS4212, SOC_EXYNOS4412 and SOC_EXYNOS5250
> should select PINCTRL_EXYNOS and SOC_EXYNOS5440 should be left as is,
> selecting PINCTRL_EXYNOS5440.

OK, sounds reasonable.  I didn't dig into all of the details of the
5440 pin control driver and don't have a user manual in front of me.
I will do as you say.

New patch coming shortly.

-Doug
