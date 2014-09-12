Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaILSWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:22:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaILSWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:22:07 -0400
Date: Fri, 12 Sep 2014 11:22:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] char/misc driver fixes for 3.17-rc5
Message-ID: <20140912182207.GA2207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.17-rc5

for you to fetch changes up to 3f0d97d97f2b539cf9ac746be4ec097259e6a8d0:

  Lattice ECP3 FPGA: Check firmware pointer (2014-09-08 14:38:14 -0700)

----------------------------------------------------------------
Char/Misc driver fix for 3.17-rc5

Here is one misc driver fix for 3.17-rc5.  It resolves a kernel oops
that can happen in the lattice FPGA driver if the firmware isn't
present on the system.

It's been in the linux-next tree for a while now.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Jean-Michel Hautbois (1):
      Lattice ECP3 FPGA: Check firmware pointer

 drivers/misc/lattice-ecp3-config.c | 5 +++++
 1 file changed, 5 insertions(+)
