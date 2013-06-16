Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab3FPM0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 08:26:14 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:45377 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab3FPM0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 08:26:13 -0400
MIME-Version: 1.0
In-Reply-To: <201306161245.30465.heiko@sntech.de>
References: <201306141741.46077.heiko@sntech.de>
	<201306141742.21808.heiko@sntech.de>
	<CACRpkdaV78wXxGPFWVffEfnqrmhq1rsdVYdSKNx5mWaOcYOWrQ@mail.gmail.com>
	<201306161245.30465.heiko@sntech.de>
Date: Sun, 16 Jun 2013 14:26:12 +0200
Message-ID: <CACRpkdZrqpshFUnphphcpTDOiga4QHkyZZFYyVmswdLQaMQj2w@mail.gmail.com>
Subject: Re: [PATCH 1/5] pinctrl: update the documentation for some pinconfig params
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 12:45 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Sonntag, 16. Juni 2013, 12:26:38 schrieb Linus Walleij:

>> Can't we rely on PIN_CONFIG_BIAS_DISABLE for all this?
>
> you're the boss on this, I'll do whatever you say :-)

Oh that's not good. As can be seen from past experience I am often
avoiding to do horrible design mistakes by other smart people telling
me how wrong I am ...

> Actually I'm too more comfortable with only using bias-disable.
>
> So I'll redo this patch to remove the disabling of a pull via this method, if
> that's the right way to go.

I sent some patch on how I'd like it defined, please check it.

> Same with the rockchip driver.

Hm I merged that patch actually, but you can send a v2 if you want
me to replace it. Or a patch on top, if preferred.

Yours,
Linus Walleij
