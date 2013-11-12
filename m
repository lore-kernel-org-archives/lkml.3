Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab3KLK3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:29:41 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37188 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab3KLK3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:29:38 -0500
MIME-Version: 1.0
In-Reply-To: <52813100.1060500@wwwdotorg.org>
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de>
	<1521079.WSLhhfqBXl@lem-wkst-02>
	<52261BF0.4090106@wwwdotorg.org>
	<3144247.j2q6H0KWZx@lem-wkst-02>
	<52279524.8090006@wwwdotorg.org>
	<20130909161924.GT29403@sirena.org.uk>
	<528121D5.40403@keymile.com>
	<528127B2.80109@wwwdotorg.org>
	<52812D3A.2070107@keymile.com>
	<52813100.1060500@wwwdotorg.org>
Date: Tue, 12 Nov 2013 11:29:36 +0100
Message-ID: <CACRpkdZpwwoM3h5_rXOwbN7cC72ruvTio6Z1hzMhLCDzh5VeKQ@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Gerlando Falauto <gerlando.falauto@keymile.com>,
        Mark Brown <broonie@kernel.org>, Lars Poeschel <poeschel@lemonage.de>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 8:33 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/11/2013 12:17 PM, Gerlando Falauto wrote:

>> Thanks for your answer. So it should be the parent driver to proactively
>> configure the GPIO as input, active high etc..., when an IRQ for its
>> GPIOs is requested, right?
>
> That was the conclusion of this thread, or a similar thread, yes.

Yepps second that.

And we added an API to that you can flag a GPIO as being
in use by an IRQ using gpio_lock_as_irq() from your
irq_chip callbacks.

Yours,
Linus Walleij
