Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaHCJ4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 05:56:21 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:43277 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaHCJ4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 05:56:20 -0400
Message-ID: <1407059776.5156.108.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sergey Oboguev <oboguev.public@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        khalid.aziz@oracle.com
Date: Sun, 03 Aug 2014 11:56:16 +0200
In-Reply-To: <CA+80gGaohO-RaG0_tWZJEFzisrrBpgfiw-mxMrTfSK0N=k7gQA@mail.gmail.com>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	 <8738dm9t4z.fsf@tassilo.jf.intel.com>
	 <1406532289.5133.223.camel@marge.simpson.net>
	 <CA+80gGaohO-RaG0_tWZJEFzisrrBpgfiw-mxMrTfSK0N=k7gQA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-08-02 at 17:43 -0700, Sergey Oboguev wrote:

> When reasoning about concurrency management it may be helpful to keep in mind
> the fundamental perspective that the problem space and solution space in this
> area are fragmented -- just as your message exemplifies as well, but it also
> applies across the board to all other solution techniques. There is no
> all-unifying solution that works in all use cases and for all purposes.

I'm just not seeing the beauty in your patch.  Ignoring SCHED_NORMAL
where priority escalation does not work as preemption proofing, for
realtime classes, what I see is a programmer using a mechanism designed
to initiate preemption arming his tasks with countermeasures to the very
thing he initiates.  Deferred preempt seems to be what you want, but you
invented something very different.

As noted though, you don't have to convince me.  The thing to do is chop
your patch up into a nice reviewable series, and submit it.

-Mike

