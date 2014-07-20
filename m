Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbaGTT4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 15:56:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbaGTT4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 15:56:09 -0400
Date: Sun, 20 Jul 2014 12:56:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] Driver core fixes for 3.16-rc6
Message-ID: <20140720195608.GA10437@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cd3de83f147601356395b57a8673e9c5ff1e59d1:

  Linux 3.16-rc4 (2014-07-06 12:37:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.16-rc6

for you to fetch changes up to aff008ad813c7cf3cfe7b532e7ba2c526c136f22:

  platform_get_irq: Revert to platform_get_resource if of_irq_get fails (2014-07-11 18:06:36 -0700)

----------------------------------------------------------------
driver core fix for 3.16-rc6

Here is a single driver core fix that reverts an older patch that has
been causing a number of reported problems with the platform devices.

This revert has been in linux-next for a while with no reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Guenter Roeck (1):
      platform_get_irq: Revert to platform_get_resource if of_irq_get fails

 drivers/base/platform.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)
