Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3KLTHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:07:38 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:39142 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab3KLTHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:07:33 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 00/12] Remove superfluous name casts
Date: Tue, 12 Nov 2013 20:07:13 +0100
Message-Id: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi all,

These days most "name" members in driver model structures are
"const char*", so there's no longer a need to cast const names to
"char *".

    [01/12] powerpc/windfarm: Remove superfluous name casts
    [02/12] mtd: Remove superfluous name casts
    [03/12] mtd: pasemi_nand.c: Remove superfluous name cast
    [04/12] PCI/portdrv: Remove superfluous name cast
    [05/12] pcmcia: Remove superfluous name casts
    [06/12] staging: Remove superfluous name casts
    [07/12] staging: r8188eu: Remove superfluous name cast
    [08/12] staging: usbip: Remove superfluous name cast
    [09/12] usb: core: Remove superfluous name casts
    [10/12] mtd: ms02-nv: Remove superfluous name cast
    [11/12] usb: gadget: Remove superfluous name casts
    [12/12] usb: host: Remove superfluous name casts

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
