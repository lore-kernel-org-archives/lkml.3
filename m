Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaDCSyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:54:44 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:26567 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753275AbaDCSyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:54:43 -0400
Date: Thu, 3 Apr 2014 14:54:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH v9 1/1] Tracepoint: register/unregister struct
 tracepoint
Message-ID: <20140403145441.2ca44063@gandalf.local.home>
In-Reply-To: <693620685.5916.1396547394009.JavaMail.zimbra@efficios.com>
References: <1396391508-17294-1-git-send-email-mathieu.desnoyers@efficios.com>
	<1396391508-17294-2-git-send-email-mathieu.desnoyers@efficios.com>
	<20140403131559.4ed4cf5e@gandalf.local.home>
	<693620685.5916.1396547394009.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2014 17:49:54 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:


> So my current thinking is that the pre-existing code was erroneously
> enabling tracepoints with the name of every event enabled (including
> e.g. function tracer, kprobes, etc). It was not failing because
> tracepoint.c silently accepted to enable tracepoints were not loaded
> yet.
> 

If that was true, than wouldn't the error code I added have returned an
error?

-- Steve
