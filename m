Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890AbaJDAet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:34:49 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:52594 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaJDAeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 20:34:46 -0400
X-Originating-IP: 75.92.167.159
Date: Fri, 3 Oct 2014 17:34:31 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Subject: [GIT PULL 3.17] tinification: Kconfig bugfixes for 3.17
Message-ID: <20141004003427.GA19070@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/josh/linux.git tags/tiny/kconfig-for-3.17

for you to fetch changes up to 62b4d2041117f35ab2409c9f5c4b8d3dc8e59d0f:

  init/Kconfig: Fix HAVE_FUTEX_CMPXCHG to not break up the EXPERT menu (2014-10-03 16:49:43 -0700)

----------------------------------------------------------------
Two Kconfig bugfixes for 3.17 related to tinification.  These fixes make the
Kconfig "General Setup" menu much more usable.

----------------------------------------------------------------

Neither of these fixes changes the resulting built kernel in any way;
they just improve the usability of the kconfig "General Setup" menu.
Randy Dunlap suggested them for 3.17 rather than waiting for 3.18.

Josh Triplett (2):
      init/Kconfig: Hide printk log config if CONFIG_PRINTK=n
      init/Kconfig: Fix HAVE_FUTEX_CMPXCHG to not break up the EXPERT menu

 init/Kconfig | 3 +++
 1 file changed, 3 insertions(+)
