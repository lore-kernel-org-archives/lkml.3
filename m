Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaFLVUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:20:17 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:26440 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaFLVUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:20:16 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, davidlohr@hp.com, Waiman.Long@hp.com,
        scott.norton@hp.com, aswin@hp.com, jason.low2@hp.com
Subject: [PATCH v3 0/3] mutex: Modifications to mutex
Date: Thu, 12 Jun 2014 14:20:11 -0700
Message-Id: <1402608014-11473-1-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2->v3:
- Merge patches 2 and 3 from the v2 patchset into one patch as suggested.
- Update Reviewed-by/Acked-by

v1->v2:
- Remove the MUTEX_SHOW_NO_WAITER() macro.
- Use !mutex_is_locked() instead of introducing a new MUTEX_IS_UNLOCKED() macro.
- Add more information to the changelog of the "Optimize mutex trylock slowpath"
  patch.

This patchset contains documentation fixes, optimizations, and improvements
to code clarity for mutex.

Jason Low (3):
  mutex: Correct documentation on mutex optimistic spinning
  mutex: Try-acquire mutex only if unlocked and improve code clarity
  mutex: Optimize mutex trylock slowpath

 kernel/locking/mutex.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

