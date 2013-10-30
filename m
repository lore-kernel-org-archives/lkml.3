Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab3J3V6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:58:15 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33628 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab3J3V6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:58:13 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 0/3 resend] memcg fixes for 3.12
Date: Wed, 30 Oct 2013 17:55:24 -0400
Message-Id: <1383170127-32284-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

here are 3 more fixes that should go into 3.12.

#2 is a special case.  The locking scheme is not new and
it's late in the cycle, but the context of this lock was
heavily changed after the OOM rewrite this merge window,
it would be good to have lockdep coverage in the release.

Thanks!

 mm/memcontrol.c | 54 +++++++++++++++++++++++++-----------------------------
 1 file changed, 25 insertions(+), 29 deletions(-)

