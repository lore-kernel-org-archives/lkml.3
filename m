Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaFXK75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:59:57 -0400
Received: from imap.thunk.org ([74.207.234.97]:54887 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbaFXK7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:59:55 -0400
Date: Tue, 24 Jun 2014 06:59:40 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Daniel Phillips <daniel@phunq.net>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Tux3 for review
Message-ID: <20140624105940.GH14887@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Daniel Phillips <daniel@phunq.net>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Pavel Machek <pavel@ucw.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>
References: <1402932354.2197.61.camel@dabdike.int.hansenpartnership.com>
 <20140619082129.GA4309@xo-6d-61-c0.localdomain>
 <alpine.LFD.2.00.1406191117240.2182@localhost.localdomain>
 <ad0baf8f-091f-45d0-8d9f-f72d78d0d1ff@phunq.net>
 <1403378941.2177.24.camel@dabdike.int.hansenpartnership.com>
 <e475a747-2f33-4c43-b6bd-98df2e57099a@phunq.net>
 <1403448187.1949.9.camel@jarvis.lan>
 <522aee97-34e7-4adc-adf2-c9b73aa0ef36@phunq.net>
 <1403584890.3140.18.camel@dabdike>
 <79582b70-6111-49f5-a1a9-f5701854e199@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79582b70-6111-49f5-a1a9-f5701854e199@phunq.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 02:10:52AM -0700, Daniel Phillips wrote:
> 
> That makes sense, because the patches to transform our workarounds
> into shiny new kernel hooks are still in progress, as I said. I would
> appreciate the courtesy of being permitted to take the time to do the
> work to the necessary quality without being subjected to endless
> carping about when the patches will be posted.

The feedback which you have been getting, fairly consistently I
believe, is that it is the shiny new kernel hooks that need to be
reviewed, not the workarounds.  I don't think it's a matter of people
not being willing to give you the time to do this work (take all the
time you need!); but rather that it's premature for you to be asking
for tux3 to be merged before those patches have been posted and
reviewed and found to be shiny.

Best regards,

						- Ted
