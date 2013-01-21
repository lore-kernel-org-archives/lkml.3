Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab3AUWOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:14:00 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:48044 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab3AUWN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:13:56 -0500
MIME-Version: 1.0
In-Reply-To: <1358544639-14761-7-git-send-email-maxime.ripard@free-electrons.com>
References: <1358544639-14761-1-git-send-email-maxime.ripard@free-electrons.com>
	<1358544639-14761-7-git-send-email-maxime.ripard@free-electrons.com>
Date: Mon, 21 Jan 2013 23:13:55 +0100
Message-ID: <CACRpkdYNOTcTVNMqD-q8sJ50nuwoXZLUJZpMXWa=mrZGnGY9+g@mail.gmail.com>
Subject: Re: [PATCH 6/7] tty: of_serial: Add pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Stefan Roese <sr@denx.de>, Alejandro Mery <amery@geeks.cl>,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 10:30 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> Use pinctrl to configure the SoCs pins directly from the driver.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

You can poke Greg about this which is fun because it does become
superfluous with the patch titled
"[PATCH v4] drivers/pinctrl: grab default handles from device core"
http://marc.info/?l=linux-kernel&m=135879594515932&w=2

Which will auto-grab the default state on any device.

Greg, can I have your ACK on that device core grab patch
so you don't have to merge this patch but can point out that
it solves the boilerplate problem?

Yours,
Linus Walleij
