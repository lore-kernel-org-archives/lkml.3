Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937414Ab3DJWtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:49:11 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34974 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937392Ab3DJWtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:49:08 -0400
Date: Wed, 10 Apr 2013 15:49:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc fixes for 3.9-rc6
Message-ID: <20130410224906.GA1019@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.9-rc6

for you to fetch changes up to 6d4f0139d642c45411a47879325891ce2a7c164a:

  misc/vmw_vmci: Add dependency on CONFIG_NET (2013-04-03 11:53:39 -0700)

----------------------------------------------------------------
Char/Misc fix for 3.9-rc6

Here is a single Kconfig dependancy build fix for 3.9.

It's been in linux-next for a while, and fixes a problem that has been
reported multiple times.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Guenter Roeck (1):
      misc/vmw_vmci: Add dependency on CONFIG_NET

 drivers/misc/vmw_vmci/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
