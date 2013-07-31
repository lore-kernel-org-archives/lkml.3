Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3GaF5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 01:57:03 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33771 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316Ab3GaF5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 01:57:01 -0400
Message-ID: <1375250219.2065.24.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] DT, maintainership, development
 process
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jason Cooper <jason@lakedaemon.net>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 30 Jul 2013 22:56:59 -0700
In-Reply-To: <51F8A4F3.4020003@zytor.com>
References: <20130729102452.GA2682@zurbaran>
	 <3572404.Lna8dKdTsO@vostro.rjw.lan> <20130729181733.GB31172@tuxdriver.com>
	 <4053222.hWzinV5Hra@vostro.rjw.lan> <51F8A4F3.4020003@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-30 at 22:47 -0700, H. Peter Anvin wrote:
> On 07/29/2013 03:30 PM, Rafael J. Wysocki wrote:
> > On Monday, July 29, 2013 02:17:34 PM John W. Linville wrote:
> >> On Mon, Jul 29, 2013 at 03:27:44PM +0200, Rafael J. Wysocki wrote:
> >>
> >>> That said we have the same issue with commits with just two SOB tags if
> >>> a maintainer applies a patch that nobody has responded to.  Are they going to
> >>> be regarded as "suspicious" too now?
> >>>
> >>> And what about trusting maintainers?  If Linus trusts them enough to pull from
> >>> them, why can't everybody else trust them enough to assume that they don't do
> >>> bad things on purpose?
> >>
> >> Not just Linus -- it's 'turtles all the way down' here.  As someone
> >> else suggested, a Singed-off-by in the merge commit should suffice
> >> here.  Although, I haven't always made a habit of adding S-o-b to
> >> merge commits either...
> > 
> > An SOB in the merge doesn't provide any additional information that can't
> > be retrieved from git, unless you use a different e-mail address for the
> > sign-off. :-)
> > 
> 
> Watch out for fast forward merges.  Ideally I guess maintainers really
> should disable fast forwards and PGP-sign their merge commits...

If you always pull from a signed tag, this isn't a problem.

James


