Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab3CAXsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 18:48:13 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:62236 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab3CAXsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 18:48:12 -0500
Date: Fri, 1 Mar 2013 15:48:08 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patch revert for 3.9-rc1
Message-ID: <20130301234808.GA11358@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 74e1a2a39355b2d3ae8c60c78d8add162c6d7183:

  Merge tag 'usb-3.9-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb (2013-02-21 12:20:00 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.9-rc1

for you to fetch changes up to 221f8dfca89276d8aec54c6d07fbe20c281668f0:

  USB: EHCI: revert "remove ASS/PSS polling timeout" (2013-02-26 13:22:38 -0800)

----------------------------------------------------------------
USB patch revert for 3.9-rc1

Here is one remaining USB patch for 3.9-rc1, it reverts a 3.8 patch that has
caused a lot of regressions for some VIA EHCI controllers.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (1):
      USB: EHCI: revert "remove ASS/PSS polling timeout"

 drivers/usb/host/ehci-timer.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)
