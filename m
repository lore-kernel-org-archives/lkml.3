Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaIHGs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 02:48:58 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:60801 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbaIHGs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 02:48:57 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.61.81]
In-Reply-To: <1408350877-15921-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1408350877-15921-1-git-send-email-javier.martinez@collabora.co.uk>
Date: Mon, 8 Sep 2014 08:48:55 +0200
Message-ID: <CABxcv==JBH4gpTpW6JgUvzivfGij2=-6N245KWXS4+X_OaWWOg@mail.gmail.com>
Subject: Re: [PATCH v9 0/5] Add Maxim 77802 RTC support
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        rtc-linux@googlegroups.com, Doug Anderson <dianders@chromium.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alessandro,

On Mon, Aug 18, 2014 at 10:34 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> This series add support for the Real Time clock present in
> the Maxim 77802 Power Managment IC. Previously, the series
> was part of a bigger one [0] that aimed to add support for
> all the devices in the max77802 PMIC. But now the max77802
> dependencies were already merged for 3.17 so the series can
> be split and each driver can go through the relevant tree.
>
> While working on the max77802 rtc support a lot of feedback
> was given and the issues pointed out also apply to a driver
> for a similar PMIC RTC (max77686). So patches 01/05 to 04/05
> in the series are cleanups for the max77686 driver and patch
> 05/05 adds the support for the max77802 RTC.
>
> I kept the version numbering from the old series so this is
> version 9 although there were no changes on the max77802 rtc
> driver since v6 of the old series, only patches 03 and 04 were
> added on this version which are cleanups for the max77686 rtc.
>
> The series were tested on an Exynos5250 Snow (max77686) and
> Exynos5420 Peach Pit (max77802) machines and applies cleanly
> to both 3.17-rc1 and today's linux-next (20140818).
>

This series was first posted for 3.17 and you said that it was OK if
it gets merged through the MFD tree but you didn't ack the set so it
missed 3.17. The max77802 mfd driver dependency made it for 3.17 so
that's why I re-posted it for 3.18 about a month ago but got no
feedback so far...

Since we are in 3.17-rc4 already, I'm afraid that this series may miss
3.18 again. Other people show their interest in the series since it
has been reviewed and tested by many folks so it should be safe to
merge them. Is there anything else you need from me to pick the
series?

Thanks a lot and best regards,
Javier
