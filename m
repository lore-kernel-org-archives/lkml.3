Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaFWSbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:31:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaFWSbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:31:51 -0400
Date: Mon, 23 Jun 2014 14:31:37 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Don A. Bailey" <donb@securitymouse.com>
Subject: [GIT PULL] Compression bugfixes for 3.16-rc3
Message-ID: <20140623183137.GA31498@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/compress-3.16-rc3

for you to fetch changes up to 206204a1162b995e2185275167b22468c00d6b36:

  lz4: ensure length does not wrap (2014-06-23 14:12:01 -0400)

----------------------------------------------------------------
Compress bugfixes for 3.16-rc3

Here are two bugfixes for some compression functions that resolve some
errors when uncompressing some pathalogical data.  Both were found by
Don A. Bailey.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (2):
      lzo: properly check for overruns
      lz4: ensure length does not wrap

 lib/lz4/lz4_decompress.c        |  2 ++
 lib/lzo/lzo1x_decompress_safe.c | 62 +++++++++++++++++++++++++++--------------
 2 files changed, 43 insertions(+), 21 deletions(-)
