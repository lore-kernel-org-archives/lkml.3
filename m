Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbaDVPCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:02:41 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:63700 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209AbaDVPCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:02:38 -0400
MIME-Version: 1.0
In-Reply-To: <1397544101-18135-2-git-send-email-wens@csie.org>
References: <1397544101-18135-1-git-send-email-wens@csie.org>
	<1397544101-18135-2-git-send-email-wens@csie.org>
Date: Tue, 22 Apr 2014 17:02:38 +0200
Message-ID: <CACRpkdZDjC1KxM2yJqsgpg2MxBamX1EObsuahB-2c+ShuBXm8A@mail.gmail.com>
Subject: Re: [PATCH 1/7] gpiolib: gpiolib-of: Implement device tree gpio-names
 based lookup
From: Linus Walleij <linus.walleij@linaro.org>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 8:41 AM, Chen-Yu Tsai <wens@csie.org> wrote:

> This patch provides of_get_gpiod_flags_by_name(), which looks up GPIO
> phandles by name only, through gpios/gpio-names, and not by index.
>
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Like Alexandre I have no strong opinion on this alternative scheme.

However if I shall apply this patch I want ACKs from the DT maintainers
with them expressing that they want things to look like this going
forward.

Otherwise the set is stalled right here.

Yours,
Linus Walleij
