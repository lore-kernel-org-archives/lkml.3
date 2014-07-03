Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbaGCOCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:02:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:8588 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755096AbaGCOCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:02:12 -0400
Date: Thu, 3 Jul 2014 10:02:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-arch@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>, Tony Lu <zlu@tilera.com>
Subject: Re: [RFA][PATCH 17/27] tile: ftrace: Remove check of obsolete
 variable function_trace_stop
Message-ID: <20140703100209.394163c5@gandalf.local.home>
In-Reply-To: <53B56061.3050601@tilera.com>
References: <20140626165221.736847419@goodmis.org>
	<20140626165852.012558348@goodmis.org>
	<53B56061.3050601@tilera.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2014 09:53:37 -0400
Chris Metcalf <cmetcalf@tilera.com> wrote:

> On 6/26/2014 12:52 PM, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)"<rostedt@goodmis.org>
> >
> > Nothing sets function_trace_stop to disable function tracing anymore.
> > Remove the check for it in the arch code.
> >
> > [ Please test this on your arch ]
> >
> > Cc: Chris Metcalf<cmetcalf@tilera.com>
> > Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
> 
> I forwarded this internally to the guy who did the work at Tilera and he's happy with the change.
> 
> Acked-by: Zhigang Lu<zlu@tilera.com>
> 

Thanks!

-- Steve
