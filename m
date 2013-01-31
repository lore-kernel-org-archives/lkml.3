Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab3AaTTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 14:19:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756369Ab3AaTTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 14:19:02 -0500
Date: Thu, 31 Jan 2013 20:17:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] uprobes/tracing: cleanups and minor fixes
Message-ID: <20130131191752.GA30410@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Cleanups and minor fixes in trace_uprobe.c. This is also preparation
for the next changes.

Please review, I am going to add this to "oleg/misc uprobes/core" tree
unless someone objects.

Oleg.

 kernel/trace/trace_probe.h  |    1 -
 kernel/trace/trace_uprobe.c |   57 ++++++++++++++++---------------------------
 2 files changed, 21 insertions(+), 37 deletions(-)

