Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaJITfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:35:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbaJITfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:35:31 -0400
Date: Thu, 9 Oct 2014 21:32:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: [PATCH 0/1] sched: make finish_task_switch() return struct rq *
Message-ID: <20141009193207.GA5408@redhat.com>
References: <20141007195046.GA28002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007195046.GA28002@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

speaking of minor cleanups...

Let me send another once before ->saved_preempt_count removal, it
looks simple and less subjective.

Again, this is just minor cleanup so please feel free to ignore, but
somehow to me this duplicated this_rq() (and the comment!) looks a
bit annoying. Plus it saves a few insns, but this is minor.

Depends on "sched: schedule_tail() should disable preemption".

Oleg.

