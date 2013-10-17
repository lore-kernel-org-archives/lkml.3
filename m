Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762711Ab3JQU5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:57:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:62783 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758245Ab3JQU46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:56:58 -0400
Date: Thu, 17 Oct 2013 16:56:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: Arend van Spriel <arend@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: trace-cmd problem with FC19
Message-ID: <20131017165656.54b8b985@gandalf.local.home>
In-Reply-To: <CAEKwDSAucy8NziB=mcem7we9vnGHe=cWt-4Q1X7+Vt5dokY19A@mail.gmail.com>
References: <525FD328.1040204@broadcom.com>
	<20131017144116.044f3aaf@gandalf.local.home>
	<52604373.5010907@broadcom.com>
	<20131017162029.002485b1@gandalf.local.home>
	<CAEKwDSAucy8NziB=mcem7we9vnGHe=cWt-4Q1X7+Vt5dokY19A@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013 16:43:08 -0400
Bob Copeland <me@bobcopeland.com> wrote:

> [sorry, resent for the archives, I failed email]
> On Thu, Oct 17, 2013 at 4:20 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Thu, 17 Oct 2013 22:07:15 +0200
> > "Arend van Spriel" <arend@broadcom.com> wrote:
> >
> >
> >> > Does recording other traces work? Or is it only spicific to this module?
> >>
> >> It seems a generic issue:
> >>
> >> $ sudo trace-cmd record -e ext4:* ls
> >> /sys/kernel/debug/tracing/events/ext4/*/filter
> >> systemd-private-6pVB5L        systemd-private-KdpFqS  trace.dat.cpu0  trace.dat.cpu2
> >> systemd-private-9hedRD        trace.dat               trace.dat.cpu1  trace.dat.cpu3
> >> trace-cmd: Interrupted system call
> >>    recorder error in splice input
> >> trace-cmd: Interrupted system call
> >>    recorder error in splice input
> >> trace-cmd: Interrupted system call
> >>    recorder error in splice input
> 
> Perhaps this is an instance of this bug?
> 
> https://lkml.org/lkml/2013/5/31/426
> 
> tl;dr try with latest trace-cmd?  I hit the above myself.
> 

Hmm, are you sure?

You may want to do both:

sudo trace-cmd -v

which trace-cmd

to see which version it is.

-- Steve
