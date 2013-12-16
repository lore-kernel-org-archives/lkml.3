Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab3LPKBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:01:21 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:57326 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab3LPKBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:01:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAEPRUYpsp_FVobY_DeEQU2+rCD7q7T=p7k++XvG-22x-OWHY8Q@mail.gmail.com>
References: <1381174108-25168-1-git-send-email-syin@broadcom.com>
	<1386787041-6035-1-git-send-email-syin@broadcom.com>
	<1386787041-6035-4-git-send-email-syin@broadcom.com>
	<CACRpkdauqYNiby-ta3c_he2ovG__0e6ubmzZ8Bx1cP_OzK4=LQ@mail.gmail.com>
	<CAEPRUYpsp_FVobY_DeEQU2+rCD7q7T=p7k++XvG-22x-OWHY8Q@mail.gmail.com>
Date: Mon, 16 Dec 2013 11:01:17 +0100
Message-ID: <CACRpkdY2BExGiL6HBg7zn_szJQMnSNsxOSuo7RyrRmrz=cVe2A@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] pinctrl: Make PINCTRL selectable by defconfig/menuconfig
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Sherman Yin <syin@broadcom.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 10:35 PM, Christian Daudt <bcm@fixthebug.org> wrote:

>  I had requested this from Sherman. The reason is so that pinctrl can
> be selectable through defconfig, instead of through SoC select
> statements. And the reason for that is so that, in the future, some of
> these can be switched into loadable modules (which can't be done from
> Kconfig). This will become necessary with the move to multiplatform -
> we won't be able to have everything static anymore.

Isn't it sufficient to make the pin controller entry tristate rather
than bool?

And as mentioned elsewhere this does not at all solve the issue
that we still need to have all basic IRQchips and timer drivers
compiled into the kernel.

Yours,
Linus Walleij
