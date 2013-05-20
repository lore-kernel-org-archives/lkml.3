Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab3ETS2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 14:28:13 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:35987 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab3ETS2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 14:28:12 -0400
MIME-Version: 1.0
In-Reply-To: <1368943247.3455.6.camel@phoenix>
References: <1368943117.3455.4.camel@phoenix>
	<1368943247.3455.6.camel@phoenix>
Date: Mon, 20 May 2013 20:28:11 +0200
Message-ID: <CACRpkdZBZ1hKU-9Je6YNSpfv=Vw9a=hyqqAqRzQX2VvA2kwqAw@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: Don't override the error code in probe error handling
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Denis Turischev <denis@compulab.co.il>,
        Lars Poeschel <poeschel@lemonage.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 19, 2013 at 8:00 AM, Axel Lin <axel.lin@ingics.com> wrote:

> Otherwise, we return 0 in probe error paths when gpiochip_remove() returns 0.
> Also show error message if gpiochip_remove() fails.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>
> Cc: Denis Turischev <denis@compulab.co.il>
> Cc: Lars Poeschel <poeschel@lemonage.de>

Good spot Axel!

Patch applied for rc-fixes.

Yours,
Linus Walleij
