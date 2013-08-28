Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3H1Nq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:46:56 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:60995 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3H1Nqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:46:53 -0400
MIME-Version: 1.0
In-Reply-To: <1377615082-16808-1-git-send-email-b.brezillon@overkiz.com>
References: <1377615082-16808-1-git-send-email-b.brezillon@overkiz.com>
Date: Wed, 28 Aug 2013 15:46:53 +0200
Message-ID: <CACRpkdbkp-aqYWO=jkBvCT0U3wbKJMBfk2N17cUZeM5rfZiU5Q@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: at91: add support for OUTPUT config
From: Linus Walleij <linus.walleij@linaro.org>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 4:51 PM, Boris BREZILLON
<b.brezillon@overkiz.com> wrote:

> Add support for pin output control through the pinctrl config:
>  - support enabling/disabling output on a given pin
>  - support output level setting (high or low)
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

NAK.

We already have this:

 * @PIN_CONFIG_OUTPUT: this will configure the pin in output, use argument
 *      1 to indicate high level, argument 0 to indicate low level.

It also has device tree bindings:

output-low              - set the pin to output mode with low level
output-high             - set the pin to output mode with high level

Yours,
Linus Walleij
