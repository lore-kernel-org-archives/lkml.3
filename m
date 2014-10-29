Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824AbaJ2XhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 19:37:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:56276 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755728AbaJ2XhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 19:37:12 -0400
Date: Wed, 29 Oct 2014 19:37:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Joe Perches <joe@perches.com>
Subject: Re: [RFA][PATCH 8/8] debugfs: Have debugfs_print_regs32() return
 void
Message-ID: <20141029193701.57c65191@gandalf.local.home>
In-Reply-To: <20141029220315.GA7276@kroah.com>
References: <20141029215602.535533597@goodmis.org>
	<20141029220108.467786659@goodmis.org>
	<20141029220315.GA7276@kroah.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014 15:03:15 -0700
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Wed, Oct 29, 2014 at 05:56:10PM -0400, Steven Rostedt wrote:
> > From: Joe Perches <joe@perches.com>
> > 
> > [ REQUEST FOR ACKS ]
> > 
> > The seq_printf() will soon just return void, and seq_has_overflowed()
> > should be used instead to see if the seq can no longer accept input.
> > 
> > As the return value of debugfs_print_regs32() has no users and
> > the seq_file descriptor should be checked with seq_has_overflowed()
> > instead of return values of functions, it is better to just have
> > debugfs_print_regs32() also return void.
> > 
> > Link: http://lkml.kernel.org/p/2634b19eb1c04a9d31148c1fe6f1f3819be95349.1412031505.git.joe@perches.com
> > 
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Joe Perches <joe@perches.com>
> > [ original change only updated seq_printf() return, added return of
> >   void to debugfs_print_regs32() as well ]
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks!

-- Steve
