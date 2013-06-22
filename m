Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab3FVOb4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 10:31:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab3FVObz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 10:31:55 -0400
Date: Sat, 22 Jun 2013 07:32:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core fixes for 3.10-rc7
Message-ID: <20130622143238.GA10957@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d132055814ef17a6c7b69f342244c410a5e000f:

  Linux 3.10-rc6 (2013-06-15 11:51:07 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.10-rc6

for you to fetch changes up to 875979368eb4cfecff9f0e97625b90cc6009269d:

  firmware loader: fix use-after-free by double abort (2013-06-18 10:41:55 -0700)

----------------------------------------------------------------
Driver core fix for 3.10-rc7

Here's a single patch for the firmware core that resolves a reported
oops in the firmware core that people have been hitting.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Ming Lei (1):
      firmware loader: fix use-after-free by double abort

 drivers/base/firmware_class.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)
