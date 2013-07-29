Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab3G2SaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:30:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52381 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab3G2SaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:30:13 -0400
Date: Mon, 29 Jul 2013 14:17:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Jason Cooper <jason@lakedaemon.net>, Samuel Ortiz <sameo@linux.intel.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] DT, maintainership, development
 process
Message-ID: <20130729181733.GB31172@tuxdriver.com>
References: <20130729102452.GA2682@zurbaran>
 <20130729113526.GB3604@zurbaran>
 <20130729130357.GQ29916@titan.lakedaemon.net>
 <3572404.Lna8dKdTsO@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3572404.Lna8dKdTsO@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 03:27:44PM +0200, Rafael J. Wysocki wrote:

> That said we have the same issue with commits with just two SOB tags if
> a maintainer applies a patch that nobody has responded to.  Are they going to
> be regarded as "suspicious" too now?
> 
> And what about trusting maintainers?  If Linus trusts them enough to pull from
> them, why can't everybody else trust them enough to assume that they don't do
> bad things on purpose?

Not just Linus -- it's 'turtles all the way down' here.  As someone
else suggested, a Singed-off-by in the merge commit should suffice
here.  Although, I haven't always made a habit of adding S-o-b to
merge commits either...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
