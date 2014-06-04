Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaFDM5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:57:32 -0400
Received: from relay.parallels.com ([195.214.232.42]:43265 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbaFDM5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:57:31 -0400
Message-ID: <1401886645.22521.39.camel@tkhai>
Subject: [PATCH 0/2] dl_{prio,task} cleanup
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        <tkhai@yandex.ru>
Date: Wed, 4 Jun 2014 16:57:25 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This cleanup series adds forgotten dl_{prio,task},
where they have to be symmetric to rt_{prio,task},
and fixes rt_prio().

---

Kirill Tkhai (2):
      sched/dl: Add necessary dl_{task,prio}
      sched/rt: Fix rt_prio()


 include/linux/sched/deadline.h |    8 +-------
 include/linux/sched/prio.h     |    8 +++++---
 include/linux/sched/rt.h       |    2 +-
 kernel/locking/mutex.c         |    8 +++++---
 kernel/sched/core.c            |    4 ++--
 5 files changed, 14 insertions(+), 16 deletions(-)

--
Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>


