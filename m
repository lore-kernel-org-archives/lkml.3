Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab3BAJnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 04:43:37 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:59064 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464Ab3BAJna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 04:43:30 -0500
MIME-Version: 1.0
In-Reply-To: <1359211016-24097-2-git-send-email-maxime.ripard@free-electrons.com>
References: <1359211016-24097-1-git-send-email-maxime.ripard@free-electrons.com>
	<1359211016-24097-2-git-send-email-maxime.ripard@free-electrons.com>
Date: Fri, 1 Feb 2013 10:43:30 +0100
Message-ID: <CACRpkdYwz113zmCBCYp8=oQ5QM8dw9sb=W7r0pe=+PeazbyOYg@mail.gmail.com>
Subject: Re: [PATCH 1/5] ARM: sunxi: Increase the number of GPIOs available
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, Alejandro Mery <amery@geeks.cl>,
        Stefan Roese <sr@denx.de>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 3:36 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> The Allwinner A10 has 9 banks of 32 GPIOs available, so it doesn't fit
> in the usual 256 limit set by gpio.h. Increase this number to 288.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Patch applied to the pinctrl tree on my allwinner branch,
with Arnd's ACK.

Yours,
Linus Walleij
