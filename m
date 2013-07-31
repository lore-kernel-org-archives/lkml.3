Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589Ab3GaRgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 13:36:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab3GaRgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:36:51 -0400
Date: Wed, 31 Jul 2013 19:31:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] tracing: kill the no longer needed PITA code
Message-ID: <20130731173116.GA31018@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Simple cleanups on top of the recent (already applied)
id/filter/format/enable changes.

f_op->owner == mod is no longer needed and can go away.

Oleg.

 kernel/trace/trace_events.c |  207 +++++--------------------------------------
 1 files changed, 22 insertions(+), 185 deletions(-)

