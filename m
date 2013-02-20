Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934478Ab3BTHmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 02:42:50 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:61044 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933765Ab3BTHms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 02:42:48 -0500
Date: Wed, 20 Feb 2013 08:35:54 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: tip/x86/amba
Message-ID: <20130220073554.GA10939@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter and maintainers.

I wonder what are the plans for the branch x86/amba, part of the tip
repository.  Of the 7 patches in that branch, 2 are already upstream
and the other 5 rebase perfectly (only conflicts are in the header
stanzas). This is the reverse log from next to my current working tree:

  0e7e31f DMA: PL330: use prefix in reg names to build under x86
  1e8486a watchdog: sp805_wdt depends on ARM
  6417077 mmc: Use the new <linux/sizes.h>
  52b9f4e drivers/amba: add support for a PCI bridge
  d8d2313 x86: add CONFIG_ARM_AMBA, selected by STA2X11

They all have the proper acked and signed-off, as well as references
to the original mailing list message by my mate Davide who submitted
them.

Shall I just wait for you to merge or shall I repost to the mailing
lists? In the latte case, with or without the various ack/signoff?

Thanks
/alessandro
