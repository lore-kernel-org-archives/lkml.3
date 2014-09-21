Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaIUTgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 15:36:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbaIUTgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 15:36:18 -0400
Date: Sun, 21 Sep 2014 21:33:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] sched: fix tg_has_rt_tasks(), tasklist_lock cleanups
Message-ID: <20140921193316.GA28596@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This textually depends on

	5d07f4202c5d63b73ba1734ed38e08461a689313
	"sched: s/do_each_thread/for_each_process_thread/ in core.c"

	d38e83c715270cc2e137bbf6f25206c8c023896b
	"sched: s/do_each_thread/for_each_process_thread/ in debug.c"

in -tip tree.

Kirill, you seem to agree with 1/3, I'll appreciate your ack.

Oleg.

