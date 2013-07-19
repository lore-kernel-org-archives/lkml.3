Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822Ab3GSPzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:55:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886Ab3GSPzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:55:43 -0400
Date: Fri, 19 Jul 2013 17:50:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] tracing: Simplify trace_array_get()
Message-ID: <20130719155041.GA19501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am a bit puzzled by trace_array_get... Could you please at
least review this change?

It is very minor and it is not needed for the changes we are
discussing, just I am worried I could miss something subtle.

IOW, I won't argue if you prefer the current "explicit" on-list
check, but I will appreciate if you explain why this change can
be wrong.

Oleg.

