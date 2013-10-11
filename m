Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab3JKIJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:09:04 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:49178 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab3JKIIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:08:55 -0400
MIME-Version: 1.0
In-Reply-To: <20131010224748.GW21581@sirena.org.uk>
References: <1381321761-8898-1-git-send-email-ldewangan@nvidia.com>
	<1381321761-8898-4-git-send-email-ldewangan@nvidia.com>
	<20131010152446.1715e64b70ddd0281a3971e9@linux-foundation.org>
	<20131010224748.GW21581@sirena.org.uk>
Date: Fri, 11 Oct 2013 10:08:54 +0200
Message-ID: <CACRpkdb1c4ZaNYa1osusprFib_N1+8n9jpjaiYYvq1WeB7bckA@mail.gmail.com>
Subject: Re: [rtc-linux] Re: [PATCH V5 3/3] drivers/rtc/rtc-as3722: add RTC driver
From: Linus Walleij <linus.walleij@linaro.org>
To: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Landley <rob@landley.net>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Florian Lobmaier <florian.lobmaier@ams.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 12:47 AM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Oct 10, 2013 at 03:24:46PM -0700, Andrew Morton wrote:
>> On Wed, 9 Oct 2013 17:59:21 +0530 Laxman Dewangan <ldewangan@nvidia.com> wrote:
>
>> > +config RTC_DRV_AS3722
>> > +   tristate "ams AS3722 RTC driver"
>> > +   depends on MFD_AS3722
>
>> ... the rtc patch depends on an mfd patch, so everyone ends up sitting
>> around looking at everyone else, wondering who will merge it all.
>
> With the MFD ones providing you trust the interfaces with the core
> are going to be OK there's no problem to just merge them via individual
> trees - the dependency on the MFD will prevent bisection problems.

Yes this is why I merged the pinctrl portions into the pinctrl tree.
We do have some indication that the MFD driver is in good shape
and will be accepted. In the worst case (if it's not getting in through
the same merge window or the next) we can just revert it.

Yours,
Linus Walleij
