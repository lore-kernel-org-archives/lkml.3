Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934677AbaJ2RSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:18:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:55478 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934119AbaJ2RSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:18:02 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbkVXCtaVY1S24bZ-q8vam729p0seGvvpKOL-AQQMywTQ@mail.gmail.com>
References: <1413539380-7046-1-git-send-email-alexandre.belloni@free-electrons.com>
	<CACRpkdbkVXCtaVY1S24bZ-q8vam729p0seGvvpKOL-AQQMywTQ@mail.gmail.com>
Date: Wed, 29 Oct 2014 10:17:56 -0700
Message-ID: <CAMAWPa_RuU73bPkxOwiqYjW3nH1DSCX+fOQ12T63SLiOVEBnyw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: at91: use own header
From: Kevin Hilman <khilman@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 9:17 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Oct 17, 2014 at 11:49 AM, Alexandre Belloni
> <alexandre.belloni@free-electrons.com> wrote:
>
>> Copy the mach/at91_pio.h header locally and use it for pinctrl-at91.c. This
>> allows to remove the dependency on mach/at91_pio.h to be able to move at91 to
>> multiplatform.
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>
> Patch applied to the pinctrl tree with Nicolas' ACK.

This patch broke the build for sama5_defconfig in next-20141029[1], as
well as the other at91*defconfigs.

Kevin

[1] http://images.armcloud.us/kernel-ci//next/next-20141029/arm-sama5_defconfig/build.log
