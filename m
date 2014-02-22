Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaBVXJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 18:09:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaBVXJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 18:09:54 -0500
Date: Sat, 22 Feb 2014 15:12:38 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PULL] TTY/Serial fix for 3.14-rc4
Message-ID: <20140222231238.GA28925@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.14-rc4

for you to fetch changes up to 5c0a2450d695bbe32b1fb81c07751bcbea64f084:

  Revert "tty: Set correct tty name in 'active' sysfs attribute" (2014-02-22 14:31:04 -0800)

----------------------------------------------------------------
TTY patch revert for 3.14-rc4

Here is a single commit, a revert of a sysfs file change that ended up
breaking a userspace tool.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      Revert "tty: Set correct tty name in 'active' sysfs attribute"

 Documentation/ABI/testing/sysfs-tty |  3 +--
 drivers/tty/tty_io.c                | 25 +++++++------------------
 2 files changed, 8 insertions(+), 20 deletions(-)
