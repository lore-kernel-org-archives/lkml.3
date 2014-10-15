Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaJOSpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 14:45:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53309 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaJOSpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 14:45:51 -0400
Date: Wed, 15 Oct 2014 14:45:49 -0400 (EDT)
Message-Id: <20141015.144549.2109697499585289654.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Oct 2014 11:45:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this sparc64 AES ctr mode bug fix.

Thanks!

The following changes since commit 2d65a9f48fcdf7866aab6457bc707ca233e0c791:

  Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux (2014-10-14 09:39:08 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to f4da3628dc7c32a59d1fb7116bb042e6f436d611:

  sparc64: Fix FPU register corruption with AES crypto offload. (2014-10-14 19:37:58 -0700)

----------------------------------------------------------------
David S. Miller (1):
      sparc64: Fix FPU register corruption with AES crypto offload.

 arch/sparc/include/asm/visasm.h |  8 ++++++++
 arch/sparc/lib/NG4memcpy.S      | 14 +++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)
