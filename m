Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab3GTTi7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 15:38:59 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:65426 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab3GTTi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 15:38:57 -0400
MIME-Version: 1.0
In-Reply-To: <1373628643-11360-1-git-send-email-peter.ujfalusi@ti.com>
References: <1373628643-11360-1-git-send-email-peter.ujfalusi@ti.com>
Date: Sat, 20 Jul 2013 21:38:57 +0200
Message-ID: <CACRpkdYJ2ugJHO512cu14uZ5Om4wKL7tq=yz_fb9sTiZne-+OQ@mail.gmail.com>
Subject: Re: [PATCH] GPIO: gpio-twl6040: Remove support for legacy (pdata) mode
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>, linux-gpio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 1:30 PM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:

> TWL6040 is used only with OMAP4/5 SoCs and they can only boot in in DT mode.
> The support for pdata/legacy boot can be removed.
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

OK patch applied.

Yours,
Linus Walleij
