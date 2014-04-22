Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbaDVOvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:51:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756819AbaDVOvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:51:06 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH RESEND 0/2] percpu_ida: Couple of tweaks
Date: Tue, 22 Apr 2014 16:51:54 +0200
Message-Id: <cover.1398178132.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The patches are against 3.15-rc2

Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>

Alexander Gordeev (2):
  percpu_ida: Move waking up waiters out of atomic contexts
  percpu_ida: Sanity check initialization parameters

 lib/percpu_ida.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

-- 
1.7.7.6

