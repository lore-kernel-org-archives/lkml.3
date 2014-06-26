Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309AbaFZTeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:34:37 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:54271 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750703AbaFZTef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:34:35 -0400
Date: Thu, 26 Jun 2014 15:34:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: Re: [RFA][PATCH 24/27] Blackfin: ftrace: Remove check of obsolete
 variable function_trace_stop
Message-ID: <20140626153432.69dbb7ca@gandalf.local.home>
In-Reply-To: <3144266.ziutPk5CNZ@vapier>
References: <20140626165221.736847419@goodmis.org>
	<20140626165853.211937817@goodmis.org>
	<3144266.ziutPk5CNZ@vapier>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 15:25:31 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> On Thu 26 Jun 2014 12:52:45 Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > Nothing sets function_trace_stop to disable function tracing anymore.
> > Remove the check for it in the arch code.
> > 
> > [ Please test this on your arch ]
> 
> i haven't tested, but the asm looks correct -- it's only using scratch 
> registers, and the rest of the code doesn't rely on the state in that ifdef 
> (by design).
> 
> Acked-by: Mike Frysinger <vapier@gentoo.org>
> -mike

Thanks!

-- Steve
