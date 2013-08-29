Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3H2R4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:56:36 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:45455 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab3H2R4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:56:34 -0400
MIME-Version: 1.0
In-Reply-To: <1377679131-32082-1-git-send-email-larsi@wh2.tu-dresden.de>
References: <1377679131-32082-1-git-send-email-larsi@wh2.tu-dresden.de>
Date: Thu, 29 Aug 2013 19:56:33 +0200
Message-ID: <CACRpkdZ9=Wd=WZ4BEQ9qiKSMTyR8gNOYVcaEB_Y_ftufKeafkQ@mail.gmail.com>
Subject: Re: [PATCH V3 1/2] gpio: mcp23s08: rename the device tree property
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

On Wed, Aug 28, 2013 at 10:38 AM, Lars Poeschel <larsi@wh2.tu-dresden.de> wrote:

> From: Lars Poeschel <poeschel@lemonage.de>
>
> The device tree property should be more descriptive.
> microchip seems more reasonable than mcp. The old mcp
> prefix is still supported but marked as deprecated.
> Users of mcp have to switch to the microchip prefix.
>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>

Patch applied.

Yours,
Linus Walleij
