Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab3HTPsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:48:15 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48570 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3HTPsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:48:14 -0400
Date: Tue, 20 Aug 2013 08:48:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Dave Hansen <dave@sr71.net>
Cc: Dave Jones <davej@redhat.com>, Anton Arapov <anton@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] [ATTEND] oops.kernel.org prospect
Message-ID: <20130820154811.GC12618@roeck-us.net>
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
> 
A per subsystem filter would be nice to have too.

Guenter
