Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbaCKMbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:31:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:32802 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752220AbaCKMbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:31:11 -0400
Date: Tue, 11 Mar 2014 08:31:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Behan Webster <behanw@converseincode.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux@arm.linux.org.uk,
        kpark3469@gmail.com, keun-o.park@windriver.com, dave.martin@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: LLVMLinux: use static inline in ARM ftrace.h
Message-ID: <20140311083107.6aa2bba4@gandalf.local.home>
In-Reply-To: <531EB4D8.6030207@converseincode.com>
References: <1392949370-26422-1-git-send-email-behanw@converseincode.com>
	<531EB4D8.6030207@converseincode.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014 00:01:44 -0700
Behan Webster <behanw@converseincode.com> wrote:

> On 02/20/14 18:22, behanw@converseincode.com wrote:
> > From: Behan Webster <behanw@converseincode.com>
> >
> > With compilers which follow the C99 standard (like modern versions of gcc and
> > clang), "extern inline" does the wrong thing (emits code for an externally
> > linkable version of the inline function). In this case using static inline
> > and removing the NULL version of return_address in return_address.c does
> > the right thing.
> Any input? Is it good as it is?

I'm fine with it. But you need approval from the arm folks. I know
there was some issues with the return_address() code in the past. But
from the ftrace perspective:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
