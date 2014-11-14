Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524AbaKNMfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 07:35:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:39325 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965171AbaKNMfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 07:35:04 -0500
Date: Fri, 14 Nov 2014 07:35:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>, kgdb-bugreport@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH RESEND 3.18-rc3 v2 1/2] trace: kdb: Fix kernel panic
 during ftdump
Message-ID: <20141114073502.107974a2@gandalf.local.home>
In-Reply-To: <20141114073146.3b360b92@gandalf.local.home>
References: <1411554781-16751-1-git-send-email-daniel.thompson@linaro.org>
	<1415277716-19419-1-git-send-email-daniel.thompson@linaro.org>
	<1415277716-19419-2-git-send-email-daniel.thompson@linaro.org>
	<20141113212646.6d720886@gandalf.local.home>
	<5465C685.9060006@linaro.org>
	<20141114065927.4156ef8e@gandalf.local.home>
	<5465F1FF.8070005@linaro.org>
	<20141114073146.3b360b92@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 07:31:46 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 14 Nov 2014 12:13:51 +0000
> Daniel Thompson <daniel.thompson@linaro.org> wrote:
> 
> > BTW I did check on kernel.org before punting them back on the list:
> > https://git.kernel.org/cgit/linux/kernel/git/rostedt/linux-trace.git/log/?h=for-next
> > 
> > Am I looking in the wrong place or are they not aimed at linux-next just
> > yet?
> 

If you want to see what I'm testing. I usually push to ftrace/core
before kicking them off. ftrace/core can rebase, so you need to be
careful with doing work on top of that.

Although, I noticed I forgot to push to my repo last night.

-- Steve
