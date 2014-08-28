Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaH1SAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:00:50 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:50450 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaH1SAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:00:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUdfmOp=POAejchTK+wKHUuKzO=6sJq1s-uOmDiPL=EcQ@mail.gmail.com>
References: <1409246765-28327-1-git-send-email-standby24x7@gmail.com>
	<CAMuHMdUdfmOp=POAejchTK+wKHUuKzO=6sJq1s-uOmDiPL=EcQ@mail.gmail.com>
Date: Fri, 29 Aug 2014 03:00:47 +0900
Message-ID: <CALLJCT0bxLboeJ3YOLTPhhekXWUPxT=3JemQt5avgR-XOXaBqA@mail.gmail.com>
Subject: Re: [PATCH] [trivial] treewide: Fix typo in printk
From: Masanari Iida <standby24x7@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Kosina <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 2:40 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> BTW, there are a few more you may want to fix:
>
> $ git grep supppor
> arch/m68k/Kconfig.devices:  This driver also suppports the ethernet
> part of the NetUSBee ROM
> drivers/scsi/esas2r/esas2r_flash.c: /* not suppported for now */;
> drivers/scsi/mpt3sas/mpt3sas_ctl.c:/*********** diagnostic trigger
> suppport *********************************/
> drivers/scsi/mpt3sas/mpt3sas_ctl.c:/*********** diagnostic trigger
> suppport *** END ****************************/
> drivers/staging/comedi/drivers/pcmuio.c: /* subdevices 0 and 2 can
> suppport interrupts */
> drivers/usb/gadget/udc/Kconfig:   high speed or full speed USB device.
> This driver supppors
> fs/f2fs/f2fs.h: /* For sysfs suppport */
> include/uapi/linux/nl80211.h: * to work properly to suppport receiving
> regulatory hints from
> kernel/trace/trace.h: * Now if the arch does not suppport a feature,
> and it calls
>
Thanks for suggestion.
I am working on fixing typos in printk messages and Documentations.
Because these typos can be found by end users, while using Linux.

Masanari
