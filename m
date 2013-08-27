Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab3H0CVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 22:21:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3H0CVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 22:21:50 -0400
Date: Mon, 26 Aug 2013 19:24:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixe for 3.11-rc8
Message-ID: <20130827022407.GA3588@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d8dfad3876e4386666b759da3c833d62fb8b2267:

  Linux 3.11-rc7 (2013-08-25 17:43:22 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.11-rc8

for you to fetch changes up to d3474049ab6cfcf14274f5ab9f20c8f50b083eab:

  USB: OHCI: fix build error related to ohci_suspend/resume (2013-08-26 15:22:15 -0700)

----------------------------------------------------------------
USB bugfix for 3.11-rc8

Here is a single bugfix that resolves the "can not build the OHCI driver
with CONFIG_PM disabled" problem that lots of people have been reporting
with 3.11-rc7.  Sorry about that one, it missed my build tests, and it
seems, a number of others as well.

Thank goodness for Guenter :)

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (1):
      USB: OHCI: fix build error related to ohci_suspend/resume

 drivers/usb/host/ohci-pci.c | 2 ++
 1 file changed, 2 insertions(+)
