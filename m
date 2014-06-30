Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaF3OQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:16:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:3704 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751001AbaF3OQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:16:35 -0400
Date: Mon, 30 Jun 2014 10:16:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arch@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: Re: [RFA][PATCH 00/27] ftrace: Remove ftrace_start/stop() and
 friends
Message-ID: <20140630101632.00274c9d@gandalf.local.home>
In-Reply-To: <53B0D5C4.8000909@hitachi.com>
References: <20140626165221.736847419@goodmis.org>
	<53B0D5C4.8000909@hitachi.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014 12:13:08 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Uh, from the same reason, I must list it in the kprobe blacklist too...

Ah yes!

> 
> BTW, as far as I can review, x86 and generic parts of the series seems
> OK to me. :)
> 

Can you post a Acked-by or Reviewed-by then?

Thanks,

-- Steve
