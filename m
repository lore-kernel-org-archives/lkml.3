Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbaFPICP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 04:02:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbaFPICN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 04:02:13 -0400
Date: Mon, 16 Jun 2014 10:02:00 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH 0/4] tools lib tracing: Updates from trace-cmd for
 plugin_kvm
Message-ID: <20140616080200.GA1148@krava.brq.redhat.com>
References: <20140613021002.444608350@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613021002.444608350@goodmis.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 10:10:02PM -0400, Steven Rostedt wrote:
> Jiri,
> 
> I'm synchronizing the changes that is in trace-cmd and the traceevent
> library. I found a few updates that are missing from the kvm plugin.

queued, also the 5/4 ;-)

thanks,
jirka

> 
> -- Steve
> 
> 
> 
> Jan Kiszka (3):
>       tools lib traceevent: Report unknown VMX exit reasons with code
>       tools lib traceevent: Factor out print_exit_reason in kvm plugin
>       tools lib traceevent: Fix and cleanup kvm_nested_vmexit tracepoints
> 
> Steven Rostedt (Red Hat) (1):
>       tools lib traceevent: Add back in kvm plugin's nested_vmexit events
> 
> ----
>  tools/lib/traceevent/plugin_kvm.c | 64 ++++++++++++++++++++++++++++++++++-----
>  1 file changed, 56 insertions(+), 8 deletions(-)
