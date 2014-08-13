Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaHMJZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:25:09 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:54850 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbaHMJZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:25:07 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Christopher Barry <christopher.r.barry@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: OT: Open letter to the Linux World
References: <20140812153812.2923046a@monolith.infinux.org>
	<20140812202129.GA20344@home.goodmis.org>
	<yw1xr40l2whi.fsf@unicorn.mansr.com>
	<20140813082756.GB2923@twins.programming.kicks-ass.net>
Date: Wed, 13 Aug 2014 10:24:58 +0100
In-Reply-To: <20140813082756.GB2923@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Wed, 13 Aug 2014 10:27:56 +0200")
Message-ID: <yw1xmwb83fo5.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Tue, Aug 12, 2014 at 11:07:05PM +0100, Måns Rullgård wrote:
>> Steven Rostedt <rostedt@goodmis.org> writes:
>> 
>> > Nice rant, I sympathize with you (just complaining about this on G+).
>> 
>> Made my day.
>> 
>> > I'm just waiting for Linus to get pissed enough to write his own init
>> > routine. Maybe he'll call it "Boot Init Through Computer Hardware".
>> 
>> The trouble is that most of the heavy-weight kernel developers don't
>> seem to care at all about what goes on in userspace.
>
> Well, I know for a fact that quite a number do; but so far most people
> who care have been able to steer clear of this trainwreck so we did.
>
> I'm about to switch all my machines to Gentoo (from Debian) because that
> will indeed allow you to build a distro without much of this nonsense
> in -- because as has been eloquently said; you simply don't need this
> fucking shite to run a 'normal' machine.

Beware, even Gentoo will pull in systemd, if in a dormant state, unless
you are very careful.

-- 
Måns Rullgård
mans@mansr.com
