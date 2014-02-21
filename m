Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbaBUTBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:01:33 -0500
Received: from imap.thunk.org ([74.207.234.97]:60880 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbaBUTBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:01:31 -0500
Date: Fri, 21 Feb 2014 14:01:25 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Simek <monstr@monstr.eu>, Felipe Balbi <balbi@ti.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        devicetree@vger.kernel.org, Wolfgang Denk <wd@denx.de>
Subject: Re: SPDX-License-Identifier
Message-ID: <20140221190125.GL31047@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michal Simek <monstr@monstr.eu>, Felipe Balbi <balbi@ti.com>,
	Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
	devicetree@vger.kernel.org, Wolfgang Denk <wd@denx.de>
References: <20140220182257.GF23217@saruman.home>
 <5306F458.9010706@monstr.eu>
 <20140221160442.GA17506@kroah.com>
 <5307790A.4050806@monstr.eu>
 <20140221161246.GM31902@saruman.home>
 <53077C5F.9000407@monstr.eu>
 <20140221162045.GN31902@saruman.home>
 <20140221165633.GA5465@kroah.com>
 <53078C30.7060703@monstr.eu>
 <20140221175720.GA21660@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221175720.GA21660@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 09:57:20AM -0800, Greg Kroah-Hartman wrote:
> > But shouldn't we at least write somewhere
> > that it has connection to spdx.org where you can find out that licenses.
> 
> Why?  Are these licenses so unknown that no one knows what they are?
> And, as part of the kernel-as-a-whole-work, they all resolve to GPLv2
> anyway, and we have that license in the source tree, so nothing else
> should be needed.

Note that not all lawyers are in agreement about this, so if this is a
driver being developed by a company, you may want to ask your
corporate counsel if they have an opinion about this.  I've received
advice of the form that it's not obvious that regardless of whether or
not us *engineers* understand what all of the licensing terms mean,
what's important is whether someone who is accused of "borrowing"
GPL'ed code and dropping it in a driver for some other OS can convince
a judge whether or not it's considered "obvious" from a legal
perspective what an SPDX header means, and what is implied by an SPDX
license identifer.

Also note that with the advent of web sites that allow people to do
web searches and turn up a singleton file via some gitweb interface,
the fact that the full license text is distributed alongside the
tarball might or might have as much legal significance as it once had.

But of course, I'm not a lawyer, and if your company has is paying for
the development of the driver, the Golden Rule applies (he who has the
Gold, makes the Rules), and each of our respective corporate lawyers
may have different opinions about what might happen if the question
was ever to be adjudicated in court.

Cheers,

					- Ted
