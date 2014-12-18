Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaLRVjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:39:09 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49150 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaLRVjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:39:07 -0500
Date: Thu, 18 Dec 2014 16:39:02 -0500 (EST)
Message-Id: <20141218.163902.82013891201636149.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Dec 2014 13:39:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this sparc32 locking bug fix from Andreas Larsson.

Thanks!

The following changes since commit 44e8967d591686463e84a88b46b03beba3ab49fb:

  Ceph: remove left-over reject file (2014-12-17 18:47:01 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to 66d0f7ec9f1038452178b1993fc07fd96d30fd38:

  sparc32: destroy_context() and switch_mm() needs to disable interrupts. (2014-12-18 12:47:54 -0500)

----------------------------------------------------------------
Andreas Larsson (1):
      sparc32: destroy_context() and switch_mm() needs to disable interrupts.

 arch/sparc/mm/srmmu.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)
