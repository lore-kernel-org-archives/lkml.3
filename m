Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaFXJLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 05:11:01 -0400
Received: from mail.phunq.net ([184.71.0.62]:37227 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbaFXJK6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 05:10:58 -0400
From: Daniel Phillips <daniel@phunq.net>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Tux3 for review
Date: Tue, 24 Jun 2014 02:10:52 -0700
User-Agent: Trojita/0.4.1; Qt/4.8.6; X11; Linux; Ubuntu 14.04 LTS
MIME-Version: 1.0
Message-ID: <79582b70-6111-49f5-a1a9-f5701854e199@phunq.net>
In-Reply-To: <1403584890.3140.18.camel@dabdike>
References: <5376B273.7000800@partner.samsung.com>
 <20140518235555.GC18954@dastard> <537AA802.408@phunq.net>
 <20140520031802.GF18954@dastard> <20140613103216.GA4589@amd.pavel.ucw.cz>
 <02d3b094-808c-4b17-903d-1280d451704b@phunq.net>
 <20140613202039.GA23872@amd.pavel.ucw.cz>
 <b67e55e1-af54-4f34-802c-95749771aca4@phunq.net>
 <1402932354.2197.61.camel@dabdike.int.hansenpartnership.com>
 <20140619082129.GA4309@xo-6d-61-c0.localdomain>
 <alpine.LFD.2.00.1406191117240.2182@localhost.localdomain>
 <ad0baf8f-091f-45d0-8d9f-f72d78d0d1ff@phunq.net>
 <1403378941.2177.24.camel@dabdike.int.hansenpartnership.com>
 <e475a747-2f33-4c43-b6bd-98df2e57099a@phunq.net>
 <1403448187.1949.9.camel@jarvis.lan>
 <522aee97-34e7-4adc-adf2-c9b73aa0ef36@phunq.net>
 <1403584890.3140.18.camel@dabdike>
Organization: tux3.org
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 23, 2014 9:41:30 PM PDT, James Bottomley wrote:
>
> [rhetoric snipped] 
>
> ... I'm still arguing the facts: proving
> that page forking can be integrated into writeback without adding to the
> maintenance burden is a big issue for tux3.

Sorry, I must have missed those facts, I only saw recycled opinions.

> We're all still waiting for the patches you were going to produce
> showing how this could be done.

That makes sense, because the patches to transform our workarounds
into shiny new kernel hooks are still in progress, as I said. I would
appreciate the courtesy of being permitted to take the time to do the
work to the necessary quality without being subjected to endless
carping about when the patches will be posted.

If there is genuine interest in how we are approaching the new mm
hooks for page forking I will happily to take the time to discuss
it.

Note that I do not complain about Dave Chinner's endless carping, which
contains much the same rhetoric as your posts, the difference being that
Dave has proved himself a good reviewer. Though Dave behaves as caustically
as you or perhaps more so, he always takes care to provide just enough
useful technical sweetener to keep the technical vs toxic balance on the
positive side. Of course, it would be much better for all if he cared to
adopt a collegial manner, like Ted for example, who incidentally can flame
with the best of them when he wants to. But who would want to, other than a
self obsessed moron?

Speaking of Dave, what would be really interesting at this point is the 
long
story of how XFS worked around pretty nearly the same writeback issues that
Tux3 does. We already saw the short story, but it went by pretty fast. 
Color
me truly interested, in part because a good solution to this is probably 
what
we really want for writeback. Not immediately, because re-engineering parts 
of
core kernel unnecessarily during a filesystem merge is simply foolhardy, 
but
at some time in the not too distant future. (CC to Dave added.)

Regards,

Daniel

