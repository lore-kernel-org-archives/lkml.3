Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3EGT7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 15:59:37 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:41252 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab3EGT7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 15:59:34 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E5C8E3@DQHE06.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E5C8E3@DQHE06.ent.ti.com>
Date: Tue, 7 May 2013 21:59:34 +0200
Message-ID: <CACRpkdb3cEhCtc=zdq6cHMnh9Hc4ELb3jDXqyhV5kzzKJ-Nxiw@mail.gmail.com>
Subject: Re: [PATCH 1/2] leds: lp55xx: support dynamic channel settings in the
 device tree structure
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Bryan Wu <cooloney@gmail.com>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 9:14 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

> Currently, the LP55xx DT structure supports max 3 channels.
> However, LP5523 has max 9 channels and LP5562 has 4 channels.
> To enhance this constraint, the DT structure has been changed.
>
>  (a) Use the child node for various channel settings instead of fixed array
>  (b) Remove 'num_channel' property.
>      This value can be retrieved by counting the children node.
>  (c) 'chan-name' property supported
>  (d) Documentation updates for LP5521 and LP5523
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

This is looking very good to me.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
