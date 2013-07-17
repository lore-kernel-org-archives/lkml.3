Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab3GQIO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 04:14:59 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36414 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab3GQIO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 04:14:56 -0400
MIME-Version: 1.0
In-Reply-To: <51E56043.1010509@linaro.org>
References: <1373024773-24574-1-git-send-email-jonas.jensen@gmail.com>
	<1373985880-23469-1-git-send-email-jonas.jensen@gmail.com>
	<51E56043.1010509@linaro.org>
Date: Wed, 17 Jul 2013 10:14:56 +0200
Message-ID: <CACmBeS129VOmFjnF+-iRH1viS+zpoaNMYMaWZ_UiPVxa6ncYeQ@mail.gmail.com>
Subject: Re: [PATCH v8] ARM: clocksource: add support for MOXA ART SoCs
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, john.stultz@linaro.org, tglx@linutronix.de,
        u.kleine-koenig@pengutronix.de, tomasz.figa@gmail.com,
        linus.walleij@linaro.org, thomas.petazzoni@free-electrons.com,
        arnd@arndb.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 July 2013 17:01, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> 1. could you elaborate the patch log: as it is a new driver, a nice
> description of the timer hardware would be valuable for people willing
> to understand the code (eg. some specificities of the driver).

A short description is now added to the commit message, I hope this is
what you wanted, I can reformat the text if needed.

> 2. fix the alignment below

I don't see the alignment error, I think this is because git adds the
one '+' character, it should be correct once applied?


Best regards,
Jonas
