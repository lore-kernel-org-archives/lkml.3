Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3GVBVy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:21:54 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:15978 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab3GVBVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:21:53 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 0/4] ipc: misc fixes & pending cleanups
Date: Sun, 21 Jul 2013 18:21:39 -0700
Message-Id: <1374456103-25353-1-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applies on top of linux-next (20130719), please consider them
for 3.12. Very straightforward patchset:

Patch 1: always check the return of find_vma in shmdt(2)
Patch 2-4: remove now mostly unused functions from the previous
           cleanups and optimizations.

Davidlohr Bueso (4):
  ipc, shm: guard against non-existant vma in shmdt(2)
  ipc: drop ipc_lock_by_ptr
  ipc, shm: drop shm_lock_check
  ipc: drop ipc_lock_check

 ipc/namespace.c |  3 ++-
 ipc/shm.c       | 14 +-------------
 ipc/util.c      | 22 ++++------------------
 ipc/util.h      |  7 -------
 4 files changed, 7 insertions(+), 39 deletions(-)

-- 
1.7.11.7

