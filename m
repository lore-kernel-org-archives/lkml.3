Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaAVJ6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 04:58:41 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:53954 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbaAVJ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:58:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFuKFfAvSPYLmvWV5jjT-peZFJ8sJ2bbh4F=JAYoWLhjZpA@mail.gmail.com>
References: <1389941251-32692-1-git-send-email-wens@csie.org>
	<CAAVeFuLP4MkfXGG1FMauvUw_J63zRXdhGwxqYy5W98L1wCQNbw@mail.gmail.com>
	<CACRpkdYiy+sya6NqRfAmsrFOXvaa3qX=qjRuTDW1vZVSaG1+Gg@mail.gmail.com>
	<201401211335.16885.arnd@arndb.de>
	<CAAVeFuKFfAvSPYLmvWV5jjT-peZFJ8sJ2bbh4F=JAYoWLhjZpA@mail.gmail.com>
Date: Wed, 22 Jan 2014 10:58:38 +0100
Message-ID: <CACRpkdZbb=eO8YRtMn6hW0vn97PkHUo88e_o61DEC8=wPY3_PQ@mail.gmail.com>
Subject: Re: [PATCH RFC 4/6] net: rfkill: gpio: add device tree support
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 3:53 PM, Alexandre Courbot <gnurou@gmail.com> wrote:

> The good (or bad, rather) thing about DT is that we can do whatever we
> please with the new bindings: decide which name or which index
> (doesn't matter here) a GPIO should have. However we don't have this
> control over ACPI, where nothing guarantees that the same index will
> be used for the same GPIO function.

It's not like ACPI will impose some tables on us and expect us to
use them as-is no matter how crazy they are. Then indeed the whole
idea of unifying ACPI and DT accessors would be moot and it would
only work by mistake or as a good joke.

The situation with ACPI is just like with DT, it is assumed that the
author of these tables also look at the Linux kernel drivers to figure
out what argument goes where and we can influence them.

Yours,
Linus Walleij
