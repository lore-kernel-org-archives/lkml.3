Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab3AWX5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 18:57:12 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:34226 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab3AWX5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 18:57:02 -0500
Date: Wed, 23 Jan 2013 15:56:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] misc fix for 3.8-rc4
Message-ID: <20130123235658.GA11781@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9a9284153d965a57edc7162a8e57c14c97f3a935:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (2013-01-20 20:55:49 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.8-rc4

for you to fetch changes up to a7e2ca17039edb5f782be519eaf9d8ea500ba7cc:

  Revert "drivers/misc/ti-st: remove gpio handling" (2013-01-22 17:22:47 -0800)

----------------------------------------------------------------
MISC driver fix for 3.8-rc4

Here is a single revert for the ti-st misc driver, fixing problem that was
introduced in 3.7-rc1 that has been bothering people.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Luciano Coelho (1):
      Revert "drivers/misc/ti-st: remove gpio handling"

 drivers/misc/ti-st/st_kim.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)
