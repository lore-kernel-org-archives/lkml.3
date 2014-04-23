Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbaDWQ6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:58:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbaDWQ6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:58:35 -0400
Date: Wed, 23 Apr 2014 18:58:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] uprobes/tracing: uprobe_perf_open() forgets to handle
	the error from uprobe_apply()
Message-ID: <20140423165808.GA29485@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Steven, I am going to ask Ingo to pull this fix along with other
pending uprobes changes, but please let me know if you want to take
this patch.

Oleg.

 kernel/trace/trace_uprobe.c |   46 +++++++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 21 deletions(-)

