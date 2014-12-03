Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaLCNl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:41:28 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:45647 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaLCNl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:41:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAFp+6iHiC9mouT-v_yGHm5adDerCpT-s7EeWwwwYi-NzdLBnrA@mail.gmail.com>
References: <CAFp+6iF-N63YSsdv2a6=MYp_mD=eQY_Oi8=9JVNU5dG0BA7YGQ@mail.gmail.com>
	<1416834177-11170-1-git-send-email-gautam.vivek@samsung.com>
	<CAGOxZ51P30BY2sOhUeMRK64CGF1fNcc-63RCXiAqZ6Rgpv3K7Q@mail.gmail.com>
	<CAFp+6iFcMGTBQDcdK0cbcu0s9a3022nogaUvbPA2ZsCN80hRSA@mail.gmail.com>
	<CAFp+6iFaf_RMprLCLXK=o=KGSTQuVL3geKx5yfevTuvFdjYLNg@mail.gmail.com>
	<CACRpkdY8sEJMr-cxzrUEW1sqP3bGLH=Q2hDP1NBQ5m9A+RhP5Q@mail.gmail.com>
	<CAFp+6iHiC9mouT-v_yGHm5adDerCpT-s7EeWwwwYi-NzdLBnrA@mail.gmail.com>
Date: Wed, 3 Dec 2014 14:41:25 +0100
Message-ID: <CACRpkdYxh36szo5UEaJOERtgT_FcYPp+7iagXG2XZ6Aeui6PWQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] pinctrl: exynos: Add BUS1 pin controller for exynos7
From: Linus Walleij <linus.walleij@linaro.org>
To: Vivek Gautam <gautamvivek1987@gmail.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Alim Akhtar <alim.akhtar@gmail.com>,
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

On Mon, Dec 1, 2014 at 3:21 PM, Vivek Gautam <gautamvivek1987@gmail.com> wrote:
> On Fri, Nov 28, 2014 at 9:15 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

>> Apart from that, there are *again* a lot of Exynos patches flying around and
>> I start to loose track of them. If they do not apply together and start to
>> conflict I will just ask Tomasz to stack them and provide a pull request
>> again.
>
> True, this merge cycle has surely got number of exynos7 related
> patches in flight,
> which are difficult to keep track of.
> Thanks for asking Tomasz.

I will probably not take any more Exynos patches for this merge cycle and
ask Tomasz to queue the Exynos pinctrl patches for v3.20 after v3.19
merge cycle is complete, so make sure to include Tomasz on reviews.

Tomasz: OK?

Yours,
Linus Walleij
