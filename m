Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaC3XI5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:08:57 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:10911 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaC3XI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:08:56 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: mingo@kernel.org, tglx@linutronix.de
Cc: peterz@infradead.org, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] futex: updates for hb waiters
Date: Sun, 30 Mar 2014 16:08:46 -0700
Message-Id: <1396220928-4426-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we recently changed the way we account for pending waiters
back to the atomic ops variant, we can do some minor updates to
the code. The first is a necessary doc change, and the other a
small helper function. 

Please consider for 3.15.

Davidlohr Bueso (2):
  futex: update comments for ordering guarantees
  futex: add plist_del + atomic_dec helper

 kernel/futex.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

-- 
1.8.1.4

