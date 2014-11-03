Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaKCNpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:45:46 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:49685 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaKCNpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:45:44 -0500
MIME-Version: 1.0
In-Reply-To: <1414755658-96293-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1414755658-96293-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Mon, 3 Nov 2014 14:45:43 +0100
Message-ID: <CACRpkdaeeAg3M-tf+odar3m8nF=T9gQhkPL+xg0t+3JVvmNnuw@mail.gmail.com>
Subject: Re: [PATCH] leds: leds-gpio: Convert gpio_blink_set() to use GPIO descriptors
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexandre Courbot <acourbot@nvidia.com>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 12:40 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> Commit 21f2aae91e902aad ("leds: leds-gpio: Add support for GPIO
> descriptors") already converted most of the driver to use GPIO descriptors.
> What is still missing is the platform specific hook gpio_blink_set() and
> board files which pass legacy GPIO numbers to this driver in platform data.
>
> In this patch we handle the former and convert gpio_blink_set() to take
> GPIO descriptor instead. In order to do this we convert the existing four
> users to accept GPIO descriptor and translate it to legacy GPIO number in
> the platform code. This effectively "pushes" legacy GPIO number usage from
> the driver to platforms.
>
> Also add comment to the remaining block describing that it is legacy code
> path and we are getting rid of it eventually.
>
> Suggested-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
