Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552Ab3ANTja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 14:39:30 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:39665 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500Ab3ANTj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 14:39:29 -0500
Date: Mon, 14 Jan 2013 14:39:27 -0500 (EST)
From: Michel Dagenais <michel.dagenais@polymtl.ca>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-ID: <1639633930.266541358192366979.JavaMail.root@srv11.zimbra.polymtl.ca>
In-Reply-To: <68461756.264831358192004350.JavaMail.root@srv11.zimbra.polymtl.ca>
Subject: Re: [RFC] ktap: Another dynamic tracing tool for Linux
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [132.207.169.236]
X-Mailer: Zimbra 5.0.23_GA_3242.RHEL5_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.23_GA_3242.RHEL5_64)
X-Poly-FromMTA: (srv11.zimbra.polymtl.ca [132.207.4.203]) at Mon, 14 Jan 2013 19:39:27 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Jovi Zhang" <bookjovi@gmail.com> wrote:
> On Fri, Jan 11, 2013 at 10:19 PM, Michel Dagenais
> <michel.dagenais@polymtl.ca> wrote:
> > You may be interested in KGTP which implements a simple bytecode interpreter
> > in the kernel to accept GDB tracepoints
> http://code.google.com/p/kgtp/
> >
> > The bytecode is quite limited but would be easy to extend.
> KGTP is still not meet my requirement on Linux tracing.
> ktap don't have gcc or gdb dependence, it's build from scratch, with a
> clean design, this is very important.

KGTP uses the GDB remote protocol but does not use/require GDB. If you have the needed information about symbols, offsets... you can generate and send the bytecode yourself. 

> > Eventually we should be able to connect LTTng http://lttng.org/ and KGTP in
> > order to benefit from the efficiency of LTTng for activating probes and
> > retrieving data.
> You are right, LTTng should be possible, and I already planed it, also
> on some functionality of ftrace and systemtap.

Such dynamic capabilities are definitely of interest both in kernel and userspace tracing.
