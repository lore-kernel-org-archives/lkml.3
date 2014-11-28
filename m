Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbaK1WmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 17:42:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaK1WmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 17:42:07 -0500
Date: Fri, 28 Nov 2014 14:40:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PULL] TTY/Serial fixes for 3.18-rc7
Message-ID: <20141128224045.GA29589@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.18-rc7

for you to fetch changes up to a5e9ab291c608c62691b9d565104a30d931998bf:

  Revert "serial: of-serial: add PM suspend/resume support" (2014-11-25 12:46:39 -0800)

----------------------------------------------------------------
TTY/Serial fix for 3.18-rc7

Here is a single revert for the of-serial driver that resolves a
reported issue.

This revert has been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      Revert "serial: of-serial: add PM suspend/resume support"

 drivers/tty/serial/of_serial.c | 27 ---------------------------
 1 file changed, 27 deletions(-)
