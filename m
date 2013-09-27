Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab3I0MUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 08:20:45 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:51560 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab3I0MUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 08:20:42 -0400
MIME-Version: 1.0
In-Reply-To: <1380008861.28920.3.camel@phoenix>
References: <1380008771.28920.1.camel@phoenix>
	<1380008861.28920.3.camel@phoenix>
Date: Fri, 27 Sep 2013 14:20:42 +0200
Message-ID: <CACRpkdYRT0OwZo5ayKPEYb7NGa_UU7b0x5yojLVL=xHHqkTaug@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: adi2: Fix dead lock in adi_gpio_direction_output
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Sonic Zhang <sonic.zhang@analog.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 9:47 AM, Axel Lin <axel.lin@ingics.com> wrote:

> Current code hold port->lock spinlock and then try to grab the lock again
> in adi_gpio_set_value(). Fix it.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Patch applied, thanks Axel.

Sonic, when you see patches like this please look at and ACK
them.

Yours,
Linus Walleij
