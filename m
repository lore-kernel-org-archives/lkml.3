Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaF1BWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 21:22:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbaF1BWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 21:22:22 -0400
Date: Fri, 27 Jun 2014 18:26:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Don A. Bailey" <donb@securitymouse.com>
Subject: [GIT PULL] Another Compression bugfixe for 3.16-rc3
Message-ID: <20140628012632.GA19471@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 206204a1162b995e2185275167b22468c00d6b36:

  lz4: ensure length does not wrap (2014-06-23 14:12:01 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/compress-3.16-rc3

for you to fetch changes up to 4148c1f67abf823099b2d7db6851e4aea407f5ee:

  lz4: fix another possible overrun (2014-06-27 11:21:07 -0700)

----------------------------------------------------------------
Compress bugfix for 3.16-rc3

Here is another lz4 bugfix for 3.16-rc3 that resolves a reported issue
with that compression algorithm.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      lz4: fix another possible overrun

 lib/lz4/lz4_decompress.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
