Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaHMJ5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:57:07 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:54925 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbaHMJ5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:57:05 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christopher Barry <christopher.r.barry@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: OT: Open letter to the Linux World
References: <20140812153812.2923046a@monolith.infinux.org>
	<yw1xr40l2whi.fsf@unicorn.mansr.com>
	<20140813082756.GB2923@twins.programming.kicks-ass.net>
	<2838655.H5W5zNkR37@merkaba>
Date: Wed, 13 Aug 2014 10:57:01 +0100
In-Reply-To: <2838655.H5W5zNkR37@merkaba> (Martin Steigerwald's message of
	"Wed, 13 Aug 2014 11:37:28 +0200")
Message-ID: <yw1xegwk3e6q.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald <Martin@lichtvoll.de> writes:

> Am Mittwoch, 13. August 2014, 10:27:56 schrieb Peter Zijlstra:
>> On Tue, Aug 12, 2014 at 11:07:05PM +0100, Måns Rullgård wrote:
>> > Steven Rostedt <rostedt@goodmis.org> writes:
>> > > Nice rant, I sympathize with you (just complaining about this on G+).
>> > 
>> > Made my day.
>> > 
>> > > I'm just waiting for Linus to get pissed enough to write his own init
>> > > routine. Maybe he'll call it "Boot Init Through Computer Hardware".
>> > 
>> > The trouble is that most of the heavy-weight kernel developers don't
>> > seem to care at all about what goes on in userspace.
>> 
>> Well, I know for a fact that quite a number do; but so far most people
>> who care have been able to steer clear of this trainwreck so we did.
>> 
>> I'm about to switch all my machines to Gentoo (from Debian) because that
>> will indeed allow you to build a distro without much of this nonsense
>> in -- because as has been eloquently said; you simply don't need this
>> fucking shite to run a 'normal' machine.
>> 
>> And the thing is; we're all very busy so we tend to take the 'easy' way
>> out for things like this; but wholesale switching all my machines is
>> indeed painful, and I'm not liking.
>
> Just for record:
>
> Debian continues and will (for now and supposedly Jessie lifetime)
> continue to work without systemd as PID 1 using systemd-shim and
> cgmanager.

For now.  Non-systemd configurations will receive little testing, if
any.  Once enough breakage accumulates, someone will issue an ultimatum
for dropping such support entirely unless those who complain fix
everything within an unreasonably short time.  Obviously most things
will remain broken, because those who opposed systemd are not package
maintainers and have other jobs to do, and non-systemd support will be
removed.  I expect this to happen in unstable/testing within 18 months.

> That all said: I believe that any feedback like this is best served on
> systemd-devel mailing list – maybe in an attempt to express it in a
> somewhat polite, yet also direct way. Instead of on LKML, debian-user,
> debian-devel and you name it what other mailinglists. Cause that would
> increase the chance of upstream noticing it.

This discussion is not aimed at systemd developers.  We already know
they don't give a hoot.

-- 
Måns Rullgård
mans@mansr.com
