Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaEMU1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 16:27:52 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:39033 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaEMU1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 16:27:44 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: manfred@colorfullife.com, akpm@linux-foundation.org
Cc: davidlohr@hp.com, aswin@hp.com, linux-kernel@vger.kernel.org
Subject: [PATCH -next 0/5] ipc,msg: fixes and updates
Date: Tue, 13 May 2014 13:27:32 -0700
Message-Id: <1400012857-11733-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is a mix of misc updates for sysv msg queues, including
some cleanups, fixes and general updates.

Patches 1,2 are cleanups.
Patch 3 fixes how receivers deal with MSG_NOERROR flag.
Patch 4 improves lockless recv documentation.
Patch 5 (perhaps more RFC) loosens how we determine a full queue.

This applies on top of linux-next-20140513. Furthermore, it passes
all LTP test cases, please consider for 3.16.

Thanks!

Davidlohr Bueso (5):
  ipc,msg: use current->state helpers
  ipc,msg: move some msgq ns code around
  ipc,msg: always respect MSG_NOERROR
  ipc,msg: document volatile r_msg
  ipc,msg: loosen check for full queue

 ipc/msg.c | 217 +++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 110 insertions(+), 107 deletions(-)

-- 
1.8.1.4

