Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaFFP4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:56:03 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:30523 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaFFP4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:56:00 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: mpatocka@redhat.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        waiman.long@hp.com, jejb@parisc-linux.org, paulmck@linux.vnet.ibm.com,
        dave.anglin@bell.net, aswin@hp.com, davidlohr@hp.com,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: [PATCH 0/2] locking/rwsem: disable optimistic spinning for PA-RISC
Date: Fri,  6 Jun 2014 08:55:38 -0700
Message-Id: <1402070140-15090-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 adds a much needed CONFIG_RWSEM_SPIN_ON_OWNER option.
Patch 2 is a quick fix to disable optimistic spinning on PA-RISC.

Thanks!

Davidlohr Bueso (2):
  locking/rwsem: Add CONFIG_RWSEM_SPIN_ON_OWNER
  locking/rwsem: Disable optimistic spinning for PA-RISC

 include/linux/rwsem.h  | 4 ++--
 kernel/Kconfig.locks   | 4 ++++
 kernel/locking/rwsem.c | 2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

-- 
1.8.1.4

