Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3HTU6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:58:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43031 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492Ab3HTU61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:58:27 -0400
Date: Tue, 20 Aug 2013 21:58:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Dave Hansen <dave@sr71.net>
Cc: Dave Jones <davej@redhat.com>, Anton Arapov <anton@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130820205812.GZ7729@decadent.org.uk>
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
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Ksummit-2013-discuss] [ATTEND] oops.kernel.org prospect
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 08:20:04AM -0700, Dave Hansen wrote:
[...]
> This is a much more minor nit, but the source code links (like clicking
> on bad_page from here:
> https://oops.kernel.org/browse-reports/oops-detail/?id=30565#) from the
> traces for the distribution kernels link over to mainline kernel source.
>  This means that the line numbers don't _quite_ line up.  It would be
> really cool if it was able to dump you right over to a copy of the
> Debian-specific source in that bug's case.  But, this is a generic
> problem that folks have who work across lots of distros: you don't
> always have the right source in front of you for any given kernel.
[...]

For Debian kernels this should be quite easy.  The sources are
browseable at:

http://sources.debian.net/src/linux/$PACKAGE_VERSION/$FILE#L$LINE

The package version is not the same as the kernel release string,
but appears at the end of the same line in oops messages, e.g. for
<http://oops.kernel.org/browse-reports/oops-detail/?id=30218> the
package version is 3.10.1-1.

This doesn't work for versions older than 3.2, or those with the RT
patchset, as sources.debian.net can't show the patched source for
these.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
