Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbbASVIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:08:22 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:53285 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbbASVIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:08:20 -0500
MIME-Version: 1.0
In-Reply-To: <1418979967-2134-1-git-send-email-rydberg@bitmath.org>
References: <1418979967-2134-1-git-send-email-rydberg@bitmath.org>
Date: Mon, 19 Jan 2015 16:08:19 -0500
Message-ID: <CAN+gG=Gmgk+wKSnHkSAERoWt+1PqAojNSZt6jo=qmzPOqJs+3Q@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Update rydberg's addresses
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@bitmath.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 4:06 AM, Henrik Rydberg <rydberg@bitmath.org> wrote:
> My ISP finally gave up on the old mail address, so I am moving things
> over to bitmath.org instead. Also change the status fields to better
> reflect reality.
>
> Signed-off-by: Henrik Rydberg <rydberg@bitmath.org>
> ---

Dmitry, it looks like this patch never found its way to your tree...

Henrik, I just used the get_maintainer to add you on CC to an input-mt
patch series, and it ended up using the @euromail.se instead of your
still valid one. I can resend to you the patch series if you want.

Cheers,
Benjamin

>  MAINTAINERS | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c721042..62b53e8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -714,15 +714,15 @@ F:        include/uapi/linux/apm_bios.h
>  F:     drivers/char/apm-emulation.c
>
>  APPLE BCM5974 MULTITOUCH DRIVER
> -M:     Henrik Rydberg <rydberg@euromail.se>
> +M:     Henrik Rydberg <rydberg@bitmath.org>
>  L:     linux-input@vger.kernel.org
> -S:     Maintained
> +S:     Odd fixes
>  F:     drivers/input/mouse/bcm5974.c
>
>  APPLE SMC DRIVER
> -M:     Henrik Rydberg <rydberg@euromail.se>
> +M:     Henrik Rydberg <rydberg@bitmath.org>
>  L:     lm-sensors@lm-sensors.org
> -S:     Maintained
> +S:     Odd fixes
>  F:     drivers/hwmon/applesmc.c
>
>  APPLETALK NETWORK LAYER
> @@ -4813,10 +4813,10 @@ F:      include/uapi/linux/input.h
>  F:     include/linux/input/
>
>  INPUT MULTITOUCH (MT) PROTOCOL
> -M:     Henrik Rydberg <rydberg@euromail.se>
> +M:     Henrik Rydberg <rydberg@bitmath.org>
>  L:     linux-input@vger.kernel.org
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/rydberg/input-mt.git
> -S:     Maintained
> +S:     Odd fixes
>  F:     Documentation/input/multi-touch-protocol.txt
>  F:     drivers/input/input-mt.c
>  K:     \b(ABS|SYN)_MT_
> --
> 2.1.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
