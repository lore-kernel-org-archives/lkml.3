Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaHMJhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:37:07 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:54886 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbaHMJhG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:37:06 -0400
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
	<yw1xmwb83fo5.fsf@unicorn.mansr.com>
	<20140813093118.GF9918@twins.programming.kicks-ass.net>
Date: Wed, 13 Aug 2014 10:37:03 +0100
In-Reply-To: <20140813093118.GF9918@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Wed, 13 Aug 2014 11:31:18 +0200")
Message-ID: <yw1xiolw3f40.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Aug 13, 2014 at 10:24:58AM +0100, Måns Rullgård wrote:
>> Beware, even Gentoo will pull in systemd, if in a dormant state, unless
>> you are very careful.
>
> Right so I've not tried yet (busy see), but I meant to remove all the
> *Kit and other nonsense from the USE flags.

The safest way to avoid it by adding it to package.mask, then adjust USE
flags until nothing conflicts.  I do the same with dbus for good measure.

-- 
Måns Rullgård
mans@mansr.com
