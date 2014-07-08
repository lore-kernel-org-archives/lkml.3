Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaGHOhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:37:12 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:25058 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaGHOhK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:37:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+OAPAR65f5RFcIYft4djOUltWptuKTlYk=
X-DKIM: OpenDKIM Filter v2.0.1 titan B5CCE5A554A
Date: Tue, 8 Jul 2014 10:37:07 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Nick Krause <xerofoify@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Arm Compiler - Part 1 of Compiling Tests
Message-ID: <20140708143707.GC13433@titan.lakedaemon.net>
References: <CAPDOMVieG951+0chzvjmKTdpZf-fEB5mjUL9YK-rgqF3+O537w@mail.gmail.com>
 <20140707134637.GA31174@thunk.org>
 <CAPDOMVjEmVJJEd_LVpCkXC8qR7APTKeHNJQSQ5SFNuWj9BQuLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPDOMVjEmVJJEd_LVpCkXC8qR7APTKeHNJQSQ5SFNuWj9BQuLA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick,

Please don't top-post.  I've fixed it up ...

On Mon, Jul 07, 2014 at 01:35:24PM -0400, Nick Krause wrote:
> On Mon, Jul 7, 2014 at 9:46 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Mon, Jul 07, 2014 at 01:22:13AM -0400, Nick Krause wrote:
> >> Here are my logs of the builds attached  with warnings if they succeed
> >> for now failing arm configs
> >> according to the tests here,
> >
> > fs/direct-io.c: In function ‘__blockdev_direct_IO’:
> > fs/direct-io.c:1011:12: warning: ‘to’ may be used uninitialized in this
> > function [-Wmaybe-uninitialized]
> >     u = (to - from) >> blkbits;
> >
> > OK, do you see why this is a false positive?  And why asking the
> > thousands of people "in the commmunity" to all do exactly the same
> > evaluation is a massive waste of time?

I already sent a patch explaining it was a false-positive and silencing
the warning:

  http://www.gossamer-threads.com/lists/linux/kernel/1956499

> In addition all the arm configs that were failing for linux next to
> compile that didn't succeed are succeeded as of now. That seems useful
> to tell the arm developers.

We already have a buildbot running and automated boot testing.  The
mailinglist is here:

  http://lists.linaro.org/mailman/listinfo/kernel-build-reports

Links to the reports are in the emails.  Please review and see if there
is anything we're missing.  Please keep in mind this is a volunteer task
for those currently running it.  Contributions would be much more
appreciated than good ideas ;-)

thx,

Jason.
