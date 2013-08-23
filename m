Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab3HWTKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:10:05 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:61936 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab3HWTKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:10:01 -0400
MIME-Version: 1.0
In-Reply-To: <1377165378-9589-1-git-send-email-larsi@wh2.tu-dresden.de>
References: <1377165378-9589-1-git-send-email-larsi@wh2.tu-dresden.de>
Date: Fri, 23 Aug 2013 21:10:00 +0200
Message-ID: <CACRpkdZMsBynLohhNw=XyzpYns9E8QVksVJYkv3dcRJ2JHWLnA@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: mcp23s08: rename the device tree property
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: Lars Poeschel <poeschel@lemonage.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 11:56 AM, Lars Poeschel <larsi@wh2.tu-dresden.de> wrote:

> From: Lars Poeschel <poeschel@lemonage.de>
>
> The device tree property should be more descriptive.
> microchip seems more reasonable than mcp. As there are no
> in tree users of this property, so the rename can still be
> done without pain.
>
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>

So do I apply this to the GPIO tree now or what?

Are the DT custodians happy?

Yours,
Linus Walleij
