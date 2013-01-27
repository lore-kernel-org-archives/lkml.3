Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab3A0TtP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 14:49:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab3A0TtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 14:49:13 -0500
Date: Sun, 27 Jan 2013 20:48:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] uprobes: Teach debug/tracing/uprobe_events to do the
	filtering
Message-ID: <20130127194814.GA25377@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Based on git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core
on top of pre-filtering patches in kernel/uprobes.c.

Please review.

After that I'll try to change tools/perf to use this new feature.

Oleg.

