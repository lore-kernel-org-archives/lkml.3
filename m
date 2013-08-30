Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab3H3HWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 03:22:43 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:42779 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab3H3HWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 03:22:42 -0400
MIME-Version: 1.0
In-Reply-To: <1377809816-22477-1-git-send-email-simon.guinot@sequanux.org>
References: <1377809816-22477-1-git-send-email-simon.guinot@sequanux.org>
Date: Fri, 30 Aug 2013 09:22:41 +0200
Message-ID: <CACRpkdaUDezKCWK74QhzdtqFkPBGfz3HJLbB9i1bL0OJ2K__BA@mail.gmail.com>
Subject: Re: [PATCH v4] gpio: add GPIO support for F71882FG and F71889F
From: Linus Walleij <linus.walleij@linaro.org>
To: Simon Guinot <simon.guinot@sequanux.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 10:56 PM, Simon Guinot
<simon.guinot@sequanux.org> wrote:

> This patch adds support for the GPIOs found on the Fintek super-I/O
> chips F71882FG and F71889F.
>
> A super-I/O is a legacy I/O controller embedded on x86 motherboards. It
> is used to connect the low-bandwidth devices. Among others functions the
> F71882FG/F71889F provides: a parallel port, two serial ports, a keyboard
> controller, an hardware monitoring controller and some GPIO pins.
>
> Note that this super-I/Os are embedded on some Atom-based LaCie NASes.
> The GPIOs are used to control the LEDs and the hard drive power.
>
> Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
> ---
> Linus,
>
> Here is a v4 for the driver gpio-f7188x. It fixes an issue noticed by
> Guenter: the driver needs to use request_muxed_region in order to
> synchronize with the hwmon and watchdog drivers for the same chip.
>
> I should have sent this update earlier but I was waiting for more
> changes (ACPI support)... All my apologies for the inconvenience.
>
> Please drop the v3 and apply this one.

OK dropped the v3 and applied this v4 instead...

Any further changes -> incremental patches.

Yours,
Linus Walleij
