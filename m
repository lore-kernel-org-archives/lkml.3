Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaF3OLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:11:44 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:56140 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750996AbaF3OLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:11:43 -0400
Date: Mon, 30 Jun 2014 10:11:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Helge Deller <deller@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFA][PATCH 20/27] parisc: ftrace: Remove check of obsolete
 variable function_trace_stop
Message-ID: <20140630101141.07d53971@gandalf.local.home>
In-Reply-To: <53B08317.7010501@gmx.de>
References: <20140626165221.736847419@goodmis.org>
	<20140626165852.497955187@goodmis.org>
	<20140626133548.03f7b90a@gandalf.local.home>
	<53B08317.7010501@gmx.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2014 23:20:23 +0200
Helge Deller <deller@gmx.de> wrote:

> Sadly the arch-related tracing code in parisc is really broken.
> It doesn't even compile cleanly on parisc (at least on 64bit), and as I wrote you in another mail
> I really need to fix this soon (which I already started on).
> 
> But your patches look clean, so to get the basics right, I'm happy to give a 
> Acked-by: Helge Deller <deller@gmx.de>
> for the two patches which affect parisc, which are:
> [PATCH 08/27] parisc: ftrace: Add call to ftrace_graph_is_dead() in function graph code
> [PATCH 20/27] parisc: ftrace: Remove check of obsolete variable function_trace_stop

Thanks!

> 
> It would be good if you can push them through your tree.
> I assume your tree is: 
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> with branch ftrace/next. 
> Is this correct?
> If yes, I can build my patches upon this tree...
> 

Actually the patches are in my branch: rfc/remove-function-trace-stop


-- Steve
