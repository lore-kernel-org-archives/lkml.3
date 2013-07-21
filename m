Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab3GUP0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 11:26:19 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49493 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab3GUP0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 11:26:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130703041432.7351.45970.sendpatchset@w520>
References: <20130703041432.7351.45970.sendpatchset@w520>
Date: Sun, 21 Jul 2013 17:26:17 +0200
Message-ID: <CACRpkdYVFVBQmrHUQowOA=KJEM9vwoh_4LxUibBZOrfg8eyXgg@mail.gmail.com>
Subject: Re: [PATCH] gpio: em: Add pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 6:14 AM, Magnus Damm <magnus.damm@gmail.com> wrote:

> From: Magnus Damm <damm@opensource.se>
>
> Register the GPIO pin range, and request and free GPIO pins using the
> pinctrl API. The pctl_name platform data member should be used by
> platform devices to point out which pinctrl device to use.
>
> Follows same style as "dc3465a gpio-rcar: Add pinctrl support",
> by Laurent Pinchart, thanks to him.
>
> Signed-off-by: Magnus Damm <damm@opensource.se>

Patch applied.

As mentioned, Simon anyway will have a ton of deps on the
pinctrl tree so we'll need to stabilize it there and then base
subsequent work on shmobile on it.

(Allow some time before I say that anything on devel is
stable though.)

Yours,
Linus Walleij
