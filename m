Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab3C1RRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:17:46 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:49201 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab3C1RRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:17:45 -0400
Date: Thu, 28 Mar 2013 10:17:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver fixes for 3.9-rc4
Message-ID: <20130328171742.GA2637@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a937536b868b8369b98967929045f1df54234323:

  Linux 3.9-rc3 (2013-03-17 15:59:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.9-rc4

for you to fetch changes up to e4317ce877a31dbb9d96375391c1c4ad2210d637:

  staging: comedi: s626: fix continuous acquisition (2013-03-25 11:35:38 -0700)

----------------------------------------------------------------
Staging driver fixes for 3.9-rc4

Here are two tiny staging driver fixes to resolve issues that have been
reported.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Ian Abbott (1):
      staging: comedi: s626: fix continuous acquisition

Paul Bolle (1):
      staging: zcache: fix typo "64_BIT"

 drivers/staging/comedi/drivers/s626.c | 2 +-
 drivers/staging/zcache/Kconfig        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
