Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab3GELsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 07:48:46 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:49890 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab3GELsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 07:48:45 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1307051213080.11637@ionos.tec.linutronix.de>
References: <1372687359-18235-1-git-send-email-jonas.jensen@gmail.com>
	<1372940383-5957-1-git-send-email-jonas.jensen@gmail.com>
	<alpine.DEB.2.02.1307042211420.11637@ionos.tec.linutronix.de>
	<CACmBeS03Xfo7DyyYUbpBaO8TeR3g8BTPzcoOzQayk40k1soFzA@mail.gmail.com>
	<alpine.DEB.2.02.1307051213080.11637@ionos.tec.linutronix.de>
Date: Fri, 5 Jul 2013 13:48:44 +0200
Message-ID: <CACmBeS1djCBWeXwCQROtvyodCfunusr-3=CKOk294P+FF-h6wA@mail.gmail.com>
Subject: Re: [PATCH v5] ARM: clocksource: add support for MOXA ART SoCs
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, john.stultz@linaro.org, u.kleine-koenig@pengutronix.de,
        tomasz.figa@gmail.com, linus.walleij@linaro.org,
        thomas.petazzoni@free-electrons.com, arnd@arndb.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the replies Thomas.

On 5 July 2013 12:21, Thomas Gleixner <tglx@linutronix.de> wrote:
> Because you need to preserve the CR2 enable bit so your clocksource
> does not get switched off.

Yes, that was my main concern. The possibility of more flags being added.
I was experimenting with TIMEREG_CR_COUNT_UP but could never get REG_MATCH1
to work right for oneshot mode.

Please take a look at v7.

Best regards,
Jonas
