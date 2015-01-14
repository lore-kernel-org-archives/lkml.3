Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbbANMg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:36:57 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:59290 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbbANMgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:36:54 -0500
MIME-Version: 1.0
In-Reply-To: <1420621722-7428-3-git-send-email-oliver+list@schinagl.nl>
References: <1420621722-7428-1-git-send-email-oliver+list@schinagl.nl>
	<1420621722-7428-3-git-send-email-oliver+list@schinagl.nl>
Date: Wed, 14 Jan 2015 13:36:53 +0100
Message-ID: <CACRpkdY85oZT5mZNF6isVf9SGP8pCRnWQ5Db80_+isdACY1Yaw@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] gpio: add parameter to allow the use named gpios
From: Linus Walleij <linus.walleij@linaro.org>
To: Olliver Schinagl <oliver+list@schinagl.nl>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Olliver Schinagl <oliver@schinagl.nl>,
        Robin Gong <b38343@freescale.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Alexander Shiyan <shc_work@mail.ru>,
        Jingoo Han <jg1.han@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 10:08 AM, Olliver Schinagl
<oliver+list@schinagl.nl> wrote:

> From: Olliver Schinagl <oliver@schinagl.nl>
>
> The gpio binding document says that new code should always use named
> gpios. Patch 40b73183 added support to parse a list of gpios from child
> nodes, but does not make it possible to use named gpios. This patch adds
> the con_id property and implements it is done in gpiolib.c, where the
> old-style of using unnamed gpios still works.
>
> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>

Alexandre, can you please take a close look at this
patch.

Yours,
Linus Walleij
