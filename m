Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab3IYUtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:49:13 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:38182 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab3IYUtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:49:10 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rob Landley <rob@landley.net>, Nicolas Pitre <nico@fluxnic.net>,
        =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Andrew Morton <akpm@osdl.org>,
        Trivial patch monkey <trivial@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: new binutils needed for arm in 3.12-rc1
References: <alpine.LFD.2.03.1309242158340.312@syhkavp.arg>
	<1380122586.1974.84@driftwood>
	<20130925204432.GW25647@n2100.arm.linux.org.uk>
Date: Wed, 25 Sep 2013 21:49:07 +0100
In-Reply-To: <20130925204432.GW25647@n2100.arm.linux.org.uk> (Russell King's
	message of "Wed, 25 Sep 2013 21:44:32 +0100")
Message-ID: <yw1x38oswrss.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> On Wed, Sep 25, 2013 at 10:23:06AM -0500, Rob Landley wrote:
>> On 09/24/2013 09:07:57 PM, Nicolas Pitre wrote:
>>> It could be as simple as making gas accept an extra argument for
>>> instructions like dsb and just ignoring it.
>>
>> So you prefer I come up with the reversion patches locally and _not_  
>> send them upstream?
>
> This is a silly attitude.  What you're effectively saying is that we
> are never allowed to use any future ARM instructions in any Linux
> kernel because that might break your precious assembler.
>
> I've got news for you.  We're *not* going to listen to that argument.
>
> END OF DISCUSSION (everything else is just a waste of time.)

I fully agree.

-- 
Måns Rullgård
mans@mansr.com
