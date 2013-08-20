Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab3HTPUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:20:13 -0400
Received: from www.sr71.net ([198.145.64.142]:35917 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab3HTPUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:20:12 -0400
Message-ID: <52138924.1040905@sr71.net>
Date: Tue, 20 Aug 2013 08:20:04 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Anton Arapov <anton@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] [ATTEND] oops.kernel.org prospect
References: <20130819085405.GA22328@bandura.laptop> <20130819145505.GB15178@kroah.com> <20130819151643.GC19070@bandura.laptop> <20130819153939.GA23875@thunk.org> <20130819155202.GF19070@bandura.laptop> <20130819212512.GA7918@redhat.com>
In-Reply-To: <20130819212512.GA7918@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 02:25 PM, Dave Jones wrote:
> * This bug last seen: 2013-08-17
>   Also useful here would be something like:
>   Seen on: 3.2-rc2, 3.10-rc10  (You can probably just list earliest/latest rather than
>    every single kernel it's been seen on, unless you want a 'show all' button)

Once you have the "seen on" stuff sorted out, it would also be really
nice to be able to easily select bugs only seen on "versions after 3.8",
just so we can filter out some of the older stuff.  The kernel version
in the filter is useful, but would be much more so if we had ranges,
even if it was just "newer than $foo".

When you go to "Show Raw Oops", it usually doesn't show up for me in
Chrome.  There's a javascript error:

> The page at https://oops.kernel.org/browse-reports/oops-detail/?id=30565# displayed insecure content from http://oops.kernel.org/get-raw.php?id=30565&token=a94733d146ae15f8cec871d4f238956da80d7c5322f6253f9b49d4c5cc8fe8a1.

If I go over and load the page as plain old http, it works fine.  Also,
when those oopses show up, the font is variable-width.  It would
probably be a wee bit easier to read if it were displayed in a
fixed-width font.

This is a much more minor nit, but the source code links (like clicking
on bad_page from here:
https://oops.kernel.org/browse-reports/oops-detail/?id=30565#) from the
traces for the distribution kernels link over to mainline kernel source.
 This means that the line numbers don't _quite_ line up.  It would be
really cool if it was able to dump you right over to a copy of the
Debian-specific source in that bug's case.  But, this is a generic
problem that folks have who work across lots of distros: you don't
always have the right source in front of you for any given kernel.

Anyway... cool stuff.  I always forget that oops.kernel.org is there,
but it's always fun to poke around when I run across it. :)
