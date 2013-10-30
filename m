Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab3J3XJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 19:09:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42085 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3J3XJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 19:09:46 -0400
Date: Wed, 30 Oct 2013 23:09:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ming Lei <tom.leiming@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chen Gang <gang.chen@asianux.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [RFC PATCH] kernel/kallsyms.c: only show legal kernel symbol
Message-ID: <20131030230920.GQ16735@n2100.arm.linux.org.uk>
References: <20131024084559.GD16735@n2100.arm.linux.org.uk> <87mwlyclng.fsf@rustcorp.com.au> <CACVXFVO86u0h0V-1_DCkO5HNyUp2i_UsjPrVWDb-ZBtmwVk28A@mail.gmail.com> <87y55h7vcd.fsf@rustcorp.com.au> <CACVXFVPXEUX9JQ2NZvL8=J34zbw2fn202QW2SQtpKjdQ+tv=vg@mail.gmail.com> <87sivp7eai.fsf@rustcorp.com.au> <CACVXFVN7PiU1dorkeamtC9-Wg_TVQE8xFiJtad-C8q4_=Rc1Ow@mail.gmail.com> <874n82gk89.fsf@rustcorp.com.au> <20131028132348.62f7e368@tom-ThinkPad-T410> <87ob6aeyg4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ob6aeyg4.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 04:20:19PM +1030, Rusty Russell wrote:
> Ming Lei <tom.leiming@gmail.com> writes:
> > On Mon, 28 Oct 2013 13:44:30 +1030
> > Rusty Russell <rusty@rustcorp.com.au> wrote:
> >
> >> Ming Lei <tom.leiming@gmail.com> writes:
> >> 
> >> I don't know...  It would be your job, as the person making the change,
> >> to find all the users of kallsyms and prove that.
> >> 
> >> This is why it is easier not to include incorrect values in the kernel's
> >> kallsyms in the first place.
> >
> > OK, thanks for your comment, and I figured out one way to do it in
> > scripts/kallsyms.c, could you comment on below patch?
> 
> Looks great! Seems like we spent more time arguing than it took you to
> code that up.
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Russell, this seems logical for you to take along with the changes which
> caused the problem?

The changes are already in mainline since a long time (back in July/August
time).  Am I the right person to take stuff for scripts/ ?  Isn't that
more kbuild territory?
