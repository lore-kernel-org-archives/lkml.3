Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab3FNQjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:39:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3FNQjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:39:09 -0400
Date: Fri, 14 Jun 2013 09:39:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.10-rc6
Message-ID: <20130614163946.GA26018@kroah.com>
References: <20130614163851.GA25973@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614163851.GA25973@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resend with fixed subject]

The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:

  Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.10-rc5

for you to fetch changes up to 0c3f3dc68bb6e6950e8cd7851e7778c550e8dfb4:

  usb: chipidea: fix id change handling (2013-06-11 16:18:05 -0700)

----------------------------------------------------------------
USB fixes for 3.10-rc6

Here are some small USB driver fixes that resolve some reported problems
for 3.10-rc6

Nothing major, just 3 USB serial driver fixes, and two chipidea fixes.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Shishkin (2):
      usb: chipidea: fix no transceiver case
      usb: chipidea: fix id change handling

Johan Hovold (3):
      USB: f81232: fix device initialisation at open
      USB: spcp8x5: fix device initialisation at open
      USB: pl2303: fix device initialisation at open

 drivers/usb/chipidea/core.c  |  3 ++-
 drivers/usb/chipidea/udc.c   | 13 ++++++++-----
 drivers/usb/serial/f81232.c  |  8 ++++----
 drivers/usb/serial/pl2303.c  | 10 +++++-----
 drivers/usb/serial/spcp8x5.c | 10 ++++------
 5 files changed, 23 insertions(+), 21 deletions(-)
