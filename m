Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaFXAb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 20:31:58 -0400
Received: from mail.phunq.net ([184.71.0.62]:39916 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbaFXAb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 20:31:57 -0400
From: Daniel Phillips <daniel@phunq.net>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        =?utf-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
        Pavel Machek <pavel@ucw.cz>, Dave Chinner <david@fromorbit.com>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Tux3 for review
Date: Mon, 23 Jun 2014 17:31:49 -0700
User-Agent: Trojita/0.4.1; Qt/4.8.6; X11; Linux; Ubuntu 14.04 LTS
MIME-Version: 1.0
Message-ID: <69617b30-fb3e-4c35-9106-8a88d7cbdd98@phunq.net>
In-Reply-To: <20140622183450.GC5333@thunk.org>
References: <20140613103216.GA4589@amd.pavel.ucw.cz>
 <02d3b094-808c-4b17-903d-1280d451704b@phunq.net>
 <20140613202039.GA23872@amd.pavel.ucw.cz>
 <b67e55e1-af54-4f34-802c-95749771aca4@phunq.net>
 <1402932354.2197.61.camel@dabdike.int.hansenpartnership.com>
 <20140619082129.GA4309@xo-6d-61-c0.localdomain>
 <alpine.LFD.2.00.1406191117240.2182@localhost.localdomain>
 <ad0baf8f-091f-45d0-8d9f-f72d78d0d1ff@phunq.net>
 <1403378941.2177.24.camel@dabdike.int.hansenpartnership.com>
 <e475a747-2f33-4c43-b6bd-98df2e57099a@phunq.net>
 <20140622183450.GC5333@thunk.org>
Organization: tux3.org
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 22, 2014 11:34:50 AM PDT, Theodore Ts'o wrote:
> On Sat, Jun 21, 2014 at 08:32:03PM -0700, Daniel Phillips wrote:
>>> That's a bit disingenuous: the concern has always been how page forking
>>> interacted with writeback.  It's not new, it was one of the major 
things
>>> brought up at LSF 14 months ago, so you weren't just assigned this.
>> 
>> [citation needed]
>
> http://lwn.net/Articles/548091/

Thank you Ted, and also thank you for providing an example worth emulating
of collegial behavior on LKML.

Regards,

Daniel
