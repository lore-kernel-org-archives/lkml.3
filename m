Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaBVXJC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 18:09:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaBVXJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 18:09:01 -0500
Date: Sat, 22 Feb 2014 15:11:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fix for 3.14-rc4
Message-ID: <20140222231145.GA28722@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.14-rc4

for you to fetch changes up to e194fd8a5d8e0a7eeed239a8534460724b62fe2d:

  staging: binder: Fix death notifications (2014-02-21 12:30:54 -0800)

----------------------------------------------------------------
Staging tree fix for 3.14-rc4

Here is a single android driver fix for 3.14-rc4 that fixes a reported
problem in the binder driver.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Arve Hjønnevåg (1):
      staging: binder: Fix death notifications

 drivers/staging/android/binder.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)
