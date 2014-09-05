Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbaIEI0D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:26:03 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:35940 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbaIEI0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:26:00 -0400
MIME-Version: 1.0
In-Reply-To: <1409484115-1974-5-git-send-email-pramod.gurav@smartplayin.com>
References: <1409484115-1974-1-git-send-email-pramod.gurav@smartplayin.com>
	<1409484115-1974-5-git-send-email-pramod.gurav@smartplayin.com>
Date: Fri, 5 Sep 2014 10:26:00 +0200
Message-ID: <CACRpkdbciY9uLfLps_-dtpKuEP+peX_7X=yt_rBG5sBgQeeDbg@mail.gmail.com>
Subject: Re: [PATCH 4/4] pinctrl: at91: Add remove function in platform_driver at91_gpio_driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 1:21 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This adds remove function in at91_gpio_driver platform_driver so that
> driver can be unloaded cleanly.
>
> CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Again, this driver is a bool so will never exercise the .remove()
callback.

Yours,
Linus Walleij
