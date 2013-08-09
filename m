Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031714Ab3HIXwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:52:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031620Ab3HIXwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:52:46 -0400
Date: Fri, 9 Aug 2013 16:52:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.11-rc5
Message-ID: <20130809235245.GA19452@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a3f:

  Linux 3.11-rc4 (2013-08-04 13:46:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.11-rc5

for you to fetch changes up to 444ce9d44d00969479aa1d2675f305a779369194:

  MAINTAINERS: Add separate section for USB NETWORKING DRIVERS (2013-08-05 13:42:46 +0800)

----------------------------------------------------------------
USB fixes for 3.11-rc5

Here are 3 small USB fixes for 3.11-rc5.

One is a fix that the ChromeOS developers ran into on some Intel
hardware, one is a build fix, and the last is a MAINTAINERS update to
help people figure out where to send USB network driver patches.

All of these have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      Merge tag 'for-usb-linus-2013-07-31' of git://git.kernel.org/.../sarah/xhci into usb-linus

James Hogan (1):
      usb: xhci: add missing dma-mapping.h includes

Joe Perches (1):
      MAINTAINERS: Add separate section for USB NETWORKING DRIVERS

Julius Werner (1):
      usb: core: don't try to reset_device() a port that got just disconnected

 MAINTAINERS                 | 5 +++++
 drivers/usb/core/hub.c      | 5 +++--
 drivers/usb/host/xhci-mem.c | 1 +
 drivers/usb/host/xhci.c     | 1 +
 4 files changed, 10 insertions(+), 2 deletions(-)
