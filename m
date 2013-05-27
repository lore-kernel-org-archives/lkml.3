Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab3E0KnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:43:25 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:41721 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341Ab3E0KnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:43:24 -0400
MIME-Version: 1.0
In-Reply-To: <1369232581-18923-1-git-send-email-lee.jones@linaro.org>
References: <1369232581-18923-1-git-send-email-lee.jones@linaro.org>
Date: Mon, 27 May 2013 12:43:24 +0200
Message-ID: <CACRpkdYWVSriZZ5grQJ-9XM6JF2NjpeXiKrE1uCYU0KpVT80sg@mail.gmail.com>
Subject: Re: [PATCH 0/7] ARM: ux500: Change naming convention for pinctrl
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 4:22 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Our naming convention started off sensibly, but with the addition of
> more supported platforms it's slipped a little. Most compatible strings
> standardise themselves with "<vendor>,<device_name>-<device_type>",
> which we had initially with "stericsson,nmk-pinctrl", but with more
> devices to support we now have a tail, so we are using
> "<vendor>,<driver_name>-<device_type>-<device_name>", which is
> unsuitable.
>
> This patch-set ensures the standard convention is used again.

I buy this. I have applied patches 1, 4 and 6 to the ux500-devicetree
branch. I will apply the remaining patches to the Nomadik branch
(which is in another tree).

There might be some trivial conflict in drivers/pinctrl/pinctrl-nomadik.c
as a result of this being split in two trees but it'll be manageable
I think (will be resolved in ARM SoC).

Yours,
Linus Walleij
