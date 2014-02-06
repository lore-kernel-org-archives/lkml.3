Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbaBFMXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 07:23:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192AbaBFMXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 07:23:39 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH RESEND 0/3] percpu_ida: Various tweaks
Date: Thu,  6 Feb 2014 13:24:52 +0100
Message-Id: <cover.1391688720.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kent,

I am resending the series without couple of original patches.
As I understand, you have not been able to find this series
anywhere, so please note your ACKs to the first two ;)

Thanks!

Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>

Alexander Gordeev (3):
  percpu_ida: Fix data race on cpus_have_tags cpumask
  percpu_ida: Move waking up waiters out of atomic contexts
  percpu_ida: Sanity check initialization parameters

 lib/percpu_ida.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

-- 
1.7.7.6

