Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaGTT42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 15:56:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbaGTT41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 15:56:27 -0400
Date: Sun, 20 Jul 2014 12:56:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB driver fixes for 3.16-rc6
Message-ID: <20140720195626.GA13766@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1795cd9b3a91d4b5473c97f491d63892442212ab:

  Linux 3.16-rc5 (2014-07-13 14:04:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.16-rc6

for you to fetch changes up to bb86cf569bbd7ad4dce581a37c7fbd748057e9dc:

  usb: Check if port status is equal to RxDetect (2014-07-17 17:14:01 -0700)

----------------------------------------------------------------
USB fixes for 3.16-rc6

Here are 2 USB patches that resolve some reported issues, one with an
odd HUB, and one in the chipidea driver.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Abbas Raza (1):
      usb: chipidea: udc: Disable auto ZLP generation on ep0

Gavin Guo (1):
      usb: Check if port status is equal to RxDetect

 drivers/usb/chipidea/udc.c |  4 ++--
 drivers/usb/core/hub.c     | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 2 deletions(-)
