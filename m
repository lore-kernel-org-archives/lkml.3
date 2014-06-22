Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaFVSfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 14:35:07 -0400
Received: from imap.thunk.org ([74.207.234.97]:52011 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbaFVSfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 14:35:05 -0400
Date: Sun, 22 Jun 2014 14:34:50 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Daniel Phillips <daniel@phunq.net>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
        Pavel Machek <pavel@ucw.cz>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Tux3 for review
Message-ID: <20140622183450.GC5333@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Daniel Phillips <daniel@phunq.net>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Pavel Machek <pavel@ucw.cz>, Dave Chinner <david@fromorbit.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e475a747-2f33-4c43-b6bd-98df2e57099a@phunq.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 08:32:03PM -0700, Daniel Phillips wrote:
> >That's a bit disingenuous: the concern has always been how page forking
> >interacted with writeback.  It's not new, it was one of the major things
> >brought up at LSF 14 months ago, so you weren't just assigned this.
> 
> [citation needed]

http://lwn.net/Articles/548091/

						- Ted
