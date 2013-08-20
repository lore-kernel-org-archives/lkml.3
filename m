Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab3HTVjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:39:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab3HTVjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:39:04 -0400
Date: Tue, 20 Aug 2013 23:38:52 +0200
From: Anton Arapov <anton@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Dave Hansen <dave@sr71.net>, Dave Jones <davej@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] [ATTEND] oops.kernel.org prospect
Message-ID: <20130820213852.GD6750@bandura.laptop>
References: <20130819085405.GA22328@bandura.laptop>
 <20130819145505.GB15178@kroah.com>
 <20130819151643.GC19070@bandura.laptop>
 <20130819153939.GA23875@thunk.org>
 <20130819155202.GF19070@bandura.laptop>
 <20130819212512.GA7918@redhat.com>
 <52138924.1040905@sr71.net>
 <20130820205812.GZ7729@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820205812.GZ7729@decadent.org.uk>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 09:58:12PM +0100, Ben Hutchings wrote:
> On Tue, Aug 20, 2013 at 08:20:04AM -0700, Dave Hansen wrote:
> [...]
> > This is a much more minor nit, but the source code links (like clicking
> > on bad_page from here:
> > https://oops.kernel.org/browse-reports/oops-detail/?id=30565#) from the
> > traces for the distribution kernels link over to mainline kernel source.
> >  This means that the line numbers don't _quite_ line up.  It would be
> > really cool if it was able to dump you right over to a copy of the
> > Debian-specific source in that bug's case.  But, this is a generic
> > problem that folks have who work across lots of distros: you don't
> > always have the right source in front of you for any given kernel.
> [...]
> 
> For Debian kernels this should be quite easy.  The sources are
> browseable at:
> 
> http://sources.debian.net/src/linux/$PACKAGE_VERSION/$FILE#L$LINE
> 
> The package version is not the same as the kernel release string,
> but appears at the end of the same line in oops messages, e.g. for
> <http://oops.kernel.org/browse-reports/oops-detail/?id=30218> the
> package version is 3.10.1-1.
> 
> This doesn't work for versions older than 3.2, or those with the RT
> patchset, as sources.debian.net can't show the patched source for
> these.


Thanks, Ben!

Anton
