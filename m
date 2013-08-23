Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3HWCoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 22:44:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7946 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab3HWCoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 22:44:12 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=0RIxtWzSM3QA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=iqRnftYWOgEA:10 a=QyXUC8HyAAAA:8 a=irtUUQ7lqQu4PxbYgT0A:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 22 Aug 2013 22:44:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/10] tracing: trace event triggers
Message-ID: <20130822224410.05a7d59c@gandalf.local.home>
In-Reply-To: <cover.1377213245.git.tom.zanussi@linux.intel.com>
References: <cover.1377213245.git.tom.zanussi@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013 18:27:16 -0500
Tom Zanussi <tom.zanussi@linux.intel.com> wrote:

> Hi,
> 
> This is v6 of the trace event triggers patchset.  This is essentially
> the same as v5, but rebased to trace/for-next, which had a couple of
> new conflicting patches pulled in since I had cut v5.  This version
> just fixes up those conflicts.
> 
> v6:
>  - fixed up the conflicts in trace_events.c related to the actual
>    creation of the per-event 'trigger' files.

Thanks Tom!

Just to let you know, I wont be able to take a look at these till
Monday.

-- Steve
