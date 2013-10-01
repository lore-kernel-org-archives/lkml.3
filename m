Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab3JAR5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:57:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56005 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3JAR5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:57:20 -0400
Date: Tue, 01 Oct 2013 13:57:15 -0400 (EDT)
Message-Id: <20131001.135715.281466689271748264.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 01 Oct 2013 10:57:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just a single bug fix to a regression added during some strlcpy()
conversions.

Please pull, thanks a lot!

The following changes since commit 6cac446bd37d9381815fe4c2b0e7b1fd1085000c:

  Merge tag 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging (2013-09-27 10:07:47 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc master

for you to fetch changes up to 2bd161a605f1f84a5fc8a4fe8410113a94f79355:

  sparc64: Fix buggy strlcpy() conversion in ldom_reboot(). (2013-09-27 13:46:04 -0700)

----------------------------------------------------------------
David S. Miller (1):
      sparc64: Fix buggy strlcpy() conversion in ldom_reboot().

 arch/sparc/kernel/ds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
