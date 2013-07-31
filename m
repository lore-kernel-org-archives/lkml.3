Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645Ab3GaLi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:38:28 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55954 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752493Ab3GaLi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:38:26 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] DT, maintainership, development process
Date: Wed, 31 Jul 2013 13:48:36 +0200
Message-ID: <2963534.uP9oyT6an2@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51F8A4F3.4020003@zytor.com>
References: <20130729102452.GA2682@zurbaran> <4053222.hWzinV5Hra@vostro.rjw.lan> <51F8A4F3.4020003@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 30, 2013 10:47:31 PM H. Peter Anvin wrote:
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

If you submit a signed pull request, that covers all of the history in your
tree up to the top commit you're requesting to pull.

And I don't do fast forward merges.

Thanks,
Rafael

