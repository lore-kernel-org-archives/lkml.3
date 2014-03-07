Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaCGNrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:47:15 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:35901 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752969AbaCGNrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:47:14 -0500
Date: Fri, 7 Mar 2014 08:47:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/module: Replace include of tracepoint.h with
 jump_label.h in module.h
Message-ID: <20140307084712.5c68641a@gandalf.local.home>
In-Reply-To: <87txbay97b.fsf@rustcorp.com.au>
References: <20140306103414.15ab227a@gandalf.local.home>
	<87txbay97b.fsf@rustcorp.com.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Mar 2014 14:02:56 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Steven Rostedt <rostedt@goodmis.org> writes:
> > Rusty,
> >
> > Can you give an Acked-by for this patch so that I can include it in my
> > 3.15 queue. I have some patches there that need to be added before this
> > change can go in.
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> 

Thank you!

-- Steve
