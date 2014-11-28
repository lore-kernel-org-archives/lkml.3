Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaK1Pps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:45:48 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:64006 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaK1Ppp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:45:45 -0500
MIME-Version: 1.0
In-Reply-To: <CAFp+6iFaf_RMprLCLXK=o=KGSTQuVL3geKx5yfevTuvFdjYLNg@mail.gmail.com>
References: <CAFp+6iF-N63YSsdv2a6=MYp_mD=eQY_Oi8=9JVNU5dG0BA7YGQ@mail.gmail.com>
	<1416834177-11170-1-git-send-email-gautam.vivek@samsung.com>
	<CAGOxZ51P30BY2sOhUeMRK64CGF1fNcc-63RCXiAqZ6Rgpv3K7Q@mail.gmail.com>
	<CAFp+6iFcMGTBQDcdK0cbcu0s9a3022nogaUvbPA2ZsCN80hRSA@mail.gmail.com>
	<CAFp+6iFaf_RMprLCLXK=o=KGSTQuVL3geKx5yfevTuvFdjYLNg@mail.gmail.com>
Date: Fri, 28 Nov 2014 16:45:44 +0100
Message-ID: <CACRpkdY8sEJMr-cxzrUEW1sqP3bGLH=Q2hDP1NBQ5m9A+RhP5Q@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] pinctrl: exynos: Add BUS1 pin controller for exynos7
From: Linus Walleij <linus.walleij@linaro.org>
To: Vivek Gautam <gautamvivek1987@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Cc: Alim Akhtar <alim.akhtar@gmail.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "robh+dt" <robh+dt@kernel.org>, kgene <kgene@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 4:39 AM, Vivek Gautam <gautamvivek1987@gmail.com> wrote:
> On Fri, Nov 28, 2014 at 9:05 AM, Vivek Gautam <gautamvivek1987@gmail.com> wrote:

>>> On Mon, Nov 24, 2014 at 6:32 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
>>>> USB and Power regulator on Exynos7 require gpios available
>>>> in BUS1 pin controller block.
>>>> So adding the BUS1 pinctrl support.
>>>>
>>>> Signed-off-by: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
>>>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>>>> Cc: Linus Walleij <linus.walleij@linaro.org>
>
> If the change looks good, will it be possible to pick it fo 3.19-rc1 ?
> That will really help enabling USB IP on exynos7.

As you know the Exynos driver has a maintainer, Tomasz Figa, I will not
merge patches without his ACK.

Apart from that, there are *again* a lot of Exynos patches flying around and
I start to loose track of them. If they do not apply together and start to
conflict I will just ask Tomasz to stack them and provide a pull request
again.

Yours,
Linus Walleij
