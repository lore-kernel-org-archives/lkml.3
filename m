Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab3DYAIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 20:08:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45266 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab3DYAIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 20:08:50 -0400
Date: Wed, 24 Apr 2013 20:08:47 -0400 (EDT)
Message-Id: <20130424.200847.935084813305667292.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 24 Apr 2013 17:08:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this brown paper bag fix for sparc64.

Thanks!

The following changes since commit 60d509fa6a9c4653a86ad830e4c4b30360b23f0e:

  Linux 3.9-rc8 (2013-04-21 14:38:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to f0af97070acbad5d6a361f485828223a4faaa0ee:

  sparc64: Fix missing put_cpu_var() in tlb_batch_add_one() when not batching. (2013-04-24 16:52:18 -0700)

----------------------------------------------------------------
David S. Miller (1):
      sparc64: Fix missing put_cpu_var() in tlb_batch_add_one() when not batching.

 arch/sparc/mm/tlb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
