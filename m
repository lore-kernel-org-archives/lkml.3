Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaH1Rkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 13:40:42 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:34780 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaH1Rkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 13:40:41 -0400
MIME-Version: 1.0
In-Reply-To: <1409246765-28327-1-git-send-email-standby24x7@gmail.com>
References: <1409246765-28327-1-git-send-email-standby24x7@gmail.com>
Date: Thu, 28 Aug 2014 19:40:37 +0200
X-Google-Sender-Auth: URS4ZgOx3SZVhrMkGSi4YxkwceY
Message-ID: <CAMuHMdUdfmOp=POAejchTK+wKHUuKzO=6sJq1s-uOmDiPL=EcQ@mail.gmail.com>
Subject: Re: [PATCH] [trivial] treewide: Fix typo in printk
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Masanari Iida <standby24x7@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 7:26 PM, Masanari Iida <standby24x7@gmail.com> wrote:
> diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
> index d163991..2a74777 100644
> --- a/arch/m68k/Kconfig.devices
> +++ b/arch/m68k/Kconfig.devices
> @@ -73,7 +73,7 @@ config ATARI_ETHERNEC
>           ROM port. The driver works by polling instead of interrupts, so it
>           is quite slow.
>
> -         This driver also suppports the ethernet part of the NetUSBee ROM
> +         This driver also supports the ethernet part of the NetUSBee ROM
>           port combined Ethernet/USB adapter.

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

BTW, there are a few more you may want to fix:

$ git grep supppor
arch/m68k/Kconfig.devices:  This driver also suppports the ethernet
part of the NetUSBee ROM
drivers/scsi/esas2r/esas2r_flash.c: /* not suppported for now */;
drivers/scsi/mpt3sas/mpt3sas_ctl.c:/*********** diagnostic trigger
suppport *********************************/
drivers/scsi/mpt3sas/mpt3sas_ctl.c:/*********** diagnostic trigger
suppport *** END ****************************/
drivers/staging/comedi/drivers/pcmuio.c: /* subdevices 0 and 2 can
suppport interrupts */
drivers/usb/gadget/udc/Kconfig:   high speed or full speed USB device.
This driver supppors
fs/f2fs/f2fs.h: /* For sysfs suppport */
include/uapi/linux/nl80211.h: * to work properly to suppport receiving
regulatory hints from
kernel/trace/trace.h: * Now if the arch does not suppport a feature,
and it calls

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
