Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab3EFT1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 15:27:41 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39597 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab3EFT1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 15:27:40 -0400
MIME-Version: 1.0
In-Reply-To: <1367831854-31952-1-git-send-email-adrian.hunter@intel.com>
References: <1367831854-31952-1-git-send-email-adrian.hunter@intel.com>
Date: Mon, 6 May 2013 21:27:39 +0200
Message-ID: <CACRpkdYsMwAZSw9McHQE4VSsS7wUWLm+mtR1yLzdPCaQzDUo3A@mail.gmail.com>
Subject: Re: [PATCH 0/3] mmc: sdhci: support runtime PM for BYT SD cards
From: Linus Walleij <linus.walleij@linaro.org>
To: Adrian Hunter <adrian.hunter@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 11:17 AM, Adrian Hunter <adrian.hunter@intel.com> wrote:

> Here are 3 patches to support runtime PM for BYT SD cards
>
> Please note that these patches are dependent upon 2 gpio patches
> that are in linux-next and linux-gpio but not the mmc tree.
> Those patches are:
>
>         author  Mika Westerberg <mika.westerberg@linux.intel.com>       2013-04-03 10:56:54 (GMT)
>         committer       Linus Walleij <linus.walleij@linaro.org>        2013-04-11 22:31:18 (GMT)
>         commit  12028d2d216220618f76284af5f8ed510b11da55 (patch)
>         gpiolib-acpi: introduce acpi_get_gpio_by_index() helper
>
>         author  Rafael J. Wysocki <rafael.j.wysocki@intel.com>  2013-04-09 13:57:25 (GMT)
>         committer       Linus Walleij <linus.walleij@linaro.org>        2013-04-10 21:41:17 (GMT)
>         commit  7fc7acb9a0b0ff3ffdf21818fe0735ebaf4fecb8 (patch)
>         gpio / ACPI: Handle ACPI events in accordance with the spec
>
> I think those patches are queued for 3.10.
>
> cc: Linus Walleij <linus.walleij@linaro.org>

No they are currently not, and will as it looks right now *not* be in v3.10 due
to a screwup from my side, and that screwup walking the ladder to
Torvalds where it exploded. So he's not pulling the GPIO tree this merge
window.

So just sit back and synchronize this for v3.11 (surely they can be taken
through the GPIO tree if Chris gives his ACK on them).

Yours,
Linus Walleij
