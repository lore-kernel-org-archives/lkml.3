Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab3HTRDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:03:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab3HTRDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:03:07 -0400
Date: Tue, 20 Aug 2013 19:02:15 +0200
From: Anton Arapov <anton@redhat.com>
To: Dave Hansen <dave@sr71.net>
Cc: Dave Jones <davej@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] [ATTEND] oops.kernel.org prospect
Message-ID: <20130820170215.GA6750@bandura.laptop>
References: <20130819085405.GA22328@bandura.laptop>
 <20130819145505.GB15178@kroah.com>
 <20130819151643.GC19070@bandura.laptop>
 <20130819153939.GA23875@thunk.org>
 <20130819155202.GF19070@bandura.laptop>
 <20130819212512.GA7918@redhat.com>
 <52138924.1040905@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52138924.1040905@sr71.net>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 08:20:04AM -0700, Dave Hansen wrote:
> On 08/19/2013 02:25 PM, Dave Jones wrote:
> > * This bug last seen: 2013-08-17
> >   Also useful here would be something like:
> >   Seen on: 3.2-rc2, 3.10-rc10  (You can probably just list earliest/latest rather than
> >    every single kernel it's been seen on, unless you want a 'show all' button)
> 
> Once you have the "seen on" stuff sorted out, it would also be really
> nice to be able to easily select bugs only seen on "versions after 3.8",
> just so we can filter out some of the older stuff.  The kernel version
> in the filter is useful, but would be much more so if we had ranges,
> even if it was just "newer than $foo".
This is good idea.


> When you go to "Show Raw Oops", it usually doesn't show up for me in
> Chrome.  There's a javascript error:
> > The page at https://oops.kernel.org/browse-reports/oops-detail/?id=30565# displayed insecure content from http://oops.kernel.org/get-raw.php?id=30565&token=a94733d146ae15f8cec871d4f238956da80d7c5322f6253f9b49d4c5cc8fe8a1.
> If I go over and load the page as plain old http, it works fine.  Also,
> when those oopses show up, the font is variable-width.  It would
> probably be a wee bit easier to read if it were displayed in a
> fixed-width font.
The latest version of Firefox should have the same issue, it is
prohibited now to show/get insecure content under the secure
connection. I will most probably redirect any https request to http
automatically to avoid this issue.


> This is a much more minor nit, but the source code links (like clicking
> on bad_page from here:
> https://oops.kernel.org/browse-reports/oops-detail/?id=30565#) from the
> traces for the distribution kernels link over to mainline kernel source.
>  This means that the line numbers don't _quite_ line up.  It would be
> really cool if it was able to dump you right over to a copy of the
> Debian-specific source in that bug's case.  But, this is a generic
> problem that folks have who work across lots of distros: you don't
> always have the right source in front of you for any given kernel.

Will put into todo list, might be someday...

> Anyway... cool stuff.  I always forget that oops.kernel.org is there,
> but it's always fun to poke around when I run across it. :)

Thanks,
Anton.

>requests accumulated:
http://trello.com/b/ZvLKCkJX/oops-kernel-org-support-and-development
