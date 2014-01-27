Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaA0UQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:16:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbaA0UQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:16:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.13 00/10] 3.13.1-stable review
Date: Mon, 27 Jan 2014 12:17:03 -0800
Message-Id: <20140127201535.350372282@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.3
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.13.1 release.
There are 10 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Jan 29 20:15:25 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.1-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.13.1-rc1

NeilBrown <neilb@suse.de>
    md/raid5: close recently introduced race in stripe_head management.

NeilBrown <neilb@suse.de>
    md/raid5: fix long-standing problem with bitmap handling on write failure.

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Explicitly keep codec powered up in hdmi_present_sense

Guenter Roeck <linux@roeck-us.net>
    extcon: gpio: Request gpio pin before modifying its state

Jon Medhurst <tixy@linaro.org>
    serial: amba-pl011: use port lock to guard control register access

Geert Uytterhoeven <geert@linux-m68k.org>
    mm: Make {,set}page_address() static inline if WANT_PAGE_VIRTUAL

H Hartley Sweeten <hsweeten@visionengravers.com>
    staging: comedi: adl_pci9111: fix incorrect irq passed to request_irq()

H Hartley Sweeten <hsweeten@visionengravers.com>
    staging: comedi: addi_apci_1032: fix subdevice type/flags bug

Bernd Porr <mail@berndporr.me.uk>
    staging: comedi: fix result of memdup_user for user chanlist

Bob Peterson <rpeterso@redhat.com>
    GFS2: Increase i_writecount during gfs2_setattr_chown


-------------

Diffstat:

 Makefile                                        |  4 ++--
 drivers/extcon/extcon-gpio.c                    | 11 ++++++-----
 drivers/md/raid5.c                              |  9 +++++----
 drivers/staging/comedi/comedi_fops.c            |  2 ++
 drivers/staging/comedi/drivers/addi_apci_1032.c |  4 ++--
 drivers/staging/comedi/drivers/adl_pci9111.c    |  2 +-
 drivers/tty/serial/amba-pl011.c                 |  6 ++++++
 fs/gfs2/inode.c                                 | 16 +++++++++++++++-
 include/linux/mm.h                              | 13 ++++++++-----
 sound/pci/hda/patch_hdmi.c                      |  6 +++++-
 10 files changed, 52 insertions(+), 21 deletions(-)


