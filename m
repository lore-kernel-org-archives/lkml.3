Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaBJAnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 19:43:20 -0500
Received: from tundra.namei.org ([65.99.196.166]:60996 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbaBJAnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 19:43:19 -0500
Date: Mon, 10 Feb 2014 11:48:50 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [GIT] SELinux fixes
Message-ID: <alpine.LRH.2.02.1402101147421.28136@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull for 3.14

The following changes since commit 9c1db7798141e2658e4b5bb170128dfdc3270ff4:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs (2014-02-09 11:12:26 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

James Morris (1):
      Merge branch 'stable-3.14' of git://git.infradead.org/users/pcmoore/selinux into for-linus

Paul Moore (2):
      Merge tag 'v3.13' into stable-3.14
      selinux: add SOCK_DIAG_BY_FAMILY to the list of netlink message types

Stephen Smalley (1):
      SELinux:  Fix kernel BUG on empty security contexts.

 security/selinux/nlmsgtab.c    |    2 ++
 security/selinux/ss/services.c |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)


