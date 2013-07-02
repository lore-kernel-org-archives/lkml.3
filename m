Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3GBUTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:19:38 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:36561 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab3GBUTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:19:36 -0400
MIME-Version: 1.0
In-Reply-To: <1372687359-18235-1-git-send-email-jonas.jensen@gmail.com>
References: <1372332203-30228-1-git-send-email-jonas.jensen@gmail.com>
	<1372687359-18235-1-git-send-email-jonas.jensen@gmail.com>
Date: Tue, 2 Jul 2013 22:19:36 +0200
Message-ID: <CACRpkdbT3yiq79rCRK0kFe39Y6QkSZHJ+7kbcmKFH8esGEN3LQ@mail.gmail.com>
Subject: Re: [PATCH v4] ARM: clocksource: add support for MOXA ART SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 1, 2013 at 4:02 PM, Jonas Jensen <jonas.jensen@gmail.com> wrote:

> This patch adds an clocksource driver for the main timer(s)
> found on MOXA ART SoCs.
>
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

I'm pretty happy with this version, tglx points out a possible optimization
getting rid of some unnecessary reads in hotpath but anyway:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
