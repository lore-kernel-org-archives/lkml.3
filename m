Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaCIBPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 20:15:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaCIBPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 20:15:12 -0500
Date: Sat, 8 Mar 2014 17:15:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fix for 3.14-rc6
Message-ID: <20140309011547.GA12574@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:

  Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.15-rc6

for you to fetch changes up to 084b6e7765b9554699afa23a50e702a3d0ae4b24:

  staging/cxt1e1/linux.c: Correct arbitrary memory write in c4_ioctl() (2014-03-04 16:20:01 -0800)

----------------------------------------------------------------
Staging driver tree fix for 3.14-rc6

Here is a single staging driver fix for your tree.

It resolves an issue with arbritary writes to memory if a specific
driver is loaded.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Salva Peiró (1):
      staging/cxt1e1/linux.c: Correct arbitrary memory write in c4_ioctl()

 drivers/staging/cxt1e1/linux.c | 2 ++
 1 file changed, 2 insertions(+)
