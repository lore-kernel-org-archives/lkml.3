Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaBRBcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 20:32:04 -0500
Received: from forward3m.mail.yandex.net ([37.140.138.3]:46262 "EHLO
	forward3m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbaBRBcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 20:32:00 -0500
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Feb 2014 20:32:00 EST
From: zbr@ioremap.net
Envelope-From: drustafa@yandex.ru
To: =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Cc: "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1392329128-6221-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1392329128-6221-1-git-send-email-u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] w1-gpio: handle of_get_gpio() returning -EPROBE_DEFER better
MIME-Version: 1.0
Message-Id: <380901392686780@web3m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 18 Feb 2014 05:26:20 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

14.02.2014, 02:05, "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>:
> of_get_gpio() might return -EPROBE_DEFER meaning that the driver
> providing the gpio isn't ready yet. If that happens for the first gpio
> the resulting kernel output without this patch is:
>
>         w1-gpio somename: Failed to parse DT
>         platform somename: Driver w1-gpio requests probe deferral
>
> The first message is misleading and so is suppressed with this patch.
>
> Further if determining the gpio to switch the external pullup yields
> -EPROBE_DEFER this error should be passed back to the caller instead of
> just continuing without pullup.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

I'm ok with this patch, but I virtually do not understand what it does :)
Since I know nothing about device trees.

But yet it looks innocent enough to merge.
