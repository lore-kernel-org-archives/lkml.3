Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab3FQQLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:11:05 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:42550 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3FQQLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:11:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130617084106.GE16699@lukather>
References: <1370795767-9769-1-git-send-email-maxime.ripard@free-electrons.com>
	<1370795767-9769-3-git-send-email-maxime.ripard@free-electrons.com>
	<CACRpkdajdrcLy6u2cKkrpYnh0Hqx8Hjx+zJ_tfpYCfJFqWCrZA@mail.gmail.com>
	<20130617084106.GE16699@lukather>
Date: Mon, 17 Jun 2013 18:11:02 +0200
Message-ID: <CACRpkda-_6G8Uq2VEX965KeGorFSZVRD++Y2+yvp66T9pQOmEA@mail.gmail.com>
Subject: Re: [PATCH 2/6] pinctrl: sunxi: Move the pins definitions to a
 separate header
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 10:41 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> Yes, As far as I can see, we should have a pretty complete support for
> the GPIO/muxing/IRQ on the "old" allwinner SoCs (sun4i and sun5i) now.

Lucky you! My Android tablet is an Ainol Hero 2 using Actions
Semiconductor ATM7029. They don't even publish their kernel
sources nor datasheet so no chance of supporting that thing.

Yours,
Linus Walleij
