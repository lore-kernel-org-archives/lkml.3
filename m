Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab3G2WUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 18:20:47 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64039 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754181Ab3G2WUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 18:20:46 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Samuel Ortiz <sameo@linux.intel.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] DT, maintainership, development process
Date: Tue, 30 Jul 2013 00:30:54 +0200
Message-ID: <4053222.hWzinV5Hra@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130729181733.GB31172@tuxdriver.com>
References: <20130729102452.GA2682@zurbaran> <3572404.Lna8dKdTsO@vostro.rjw.lan> <20130729181733.GB31172@tuxdriver.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 29, 2013 02:17:34 PM John W. Linville wrote:
> On Mon, Jul 29, 2013 at 03:27:44PM +0200, Rafael J. Wysocki wrote:
> 
> > That said we have the same issue with commits with just two SOB tags if
> > a maintainer applies a patch that nobody has responded to.  Are they going to
> > be regarded as "suspicious" too now?
> > 
> > And what about trusting maintainers?  If Linus trusts them enough to pull from
> > them, why can't everybody else trust them enough to assume that they don't do
> > bad things on purpose?
> 
> Not just Linus -- it's 'turtles all the way down' here.  As someone
> else suggested, a Singed-off-by in the merge commit should suffice
> here.  Although, I haven't always made a habit of adding S-o-b to
> merge commits either...

An SOB in the merge doesn't provide any additional information that can't
be retrieved from git, unless you use a different e-mail address for the
sign-off. :-)

Rafael

