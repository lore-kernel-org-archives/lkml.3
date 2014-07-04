Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030955AbaGDXMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 19:12:16 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:55790 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761074AbaGDXMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 19:12:15 -0400
MIME-Version: 1.0
In-Reply-To: <1404295551-13470-3-git-send-email-rob.jones@codethink.co.uk>
References: <1404295551-13470-1-git-send-email-rob.jones@codethink.co.uk>
	<1404295551-13470-3-git-send-email-rob.jones@codethink.co.uk>
Date: Sat, 5 Jul 2014 01:12:14 +0200
Message-ID: <CACRpkdbA3YJ6O+-cbywP+-DPMT2Q9oRzqvdqjeueUvDP=oWwcQ@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] gpio: allow gpio array requests for managed devices
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: Alexandre Courbot <gnurou@gmail.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kernel@codethink.co.uk, Ian Molton <ian.molton@codethink.co.uk>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 12:05 PM, Rob Jones <rob.jones@codethink.co.uk> wrote:

> Add functions devm_gpio_request_array() and devm_gpio_free_array()
> which are exactly analogous to the equivalent non-managed device
> functions gpio_request_array() and gpio_free_array(), which can be
> found in the module gpiolib.c.
>
> Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
> Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>

OK I guess this needs to be merged through the regulator tree
so here is:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
