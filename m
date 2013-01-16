Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3APNVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:21:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab3APNVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:21:37 -0500
Date: Wed, 16 Jan 2013 08:21:27 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, dhowells@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com
Subject: Re: [PATCH] MODSIGN: Add TAINT_NOKEY_MODULE
Message-ID: <20130116132126.GE6964@hansolo.jdub.homelinux.org>
References: <20130104191205.GD27554@hansolo.jdub.homelinux.org>
 <87bod14x44.fsf@rustcorp.com.au>
 <20130107145832.GA12363@hansolo.jdub.homelinux.org>
 <20130115190911.GA6964@hansolo.jdub.homelinux.org>
 <87y5ftyf51.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5ftyf51.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 02:04:50PM +1030, Rusty Russell wrote:
> Josh Boyer <jwboyer@redhat.com> writes:
> > With module signing enabled but not in enforcing mode, we don't consider
> > unsigned modules to be an error.  However, if we encounter an unsigned
> > module we currently taint the module and kernel with TAINT_FORCED_MODULE.
> > That also disables lockdep within the kernel.
> 
> How about this, instead?  Ingo?

That would work for me for the lockdep issue, sure.  I thought I'd make
the unsigned/wrong key module case a bit more clear at the same time.
Do you think that's worth doing aside from lockdep?  If so, and your
patch seems acceptable to others, I'd be happy to respin my patch on
top.

I'll give your patch a test in just a bit.

josh
