Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab3IISjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:39:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34618 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394Ab3IISjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:39:09 -0400
Date: Mon, 9 Sep 2013 19:39:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        "John W. Linville" <linville@tuxdriver.com>
Message-ID: <20130909183904.GJ7729@decadent.org.uk>
References: <lsq.1374674564.753305150@decadent.org.uk>
 <lsq.1374674565.595401652@decadent.org.uk>
 <20130909180115.GC6276@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909180115.GC6276@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [16/85] b43: ensue that BCMA is "y" when B43 is "y"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 02:01:15PM -0400, Steven Rostedt wrote:
> On Wed, Jul 24, 2013 at 03:02:45PM +0100, Ben Hutchings wrote:
> > 3.2.49-rc1 review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Hauke Mehrtens <hauke@hauke-m.de>
> > 
> > commit 693026ef2e751fd94d2e6c71028e68343cc875d5 upstream.
> > 
> > When b43 gets build into the kernel and it should use bcma we have to
> > ensure that bcma was also build into the kernel and not as a module.
> > In this patch this is also done for SSB, although you can not
> > build b43 without ssb support for now.
> > 
> > This fixes a build problem reported by Randy Dunlap in
> > 5187EB95.2060605@infradead.org
> 
> Hauke,
> 
> Just an FYI, if you find yourself adding message id's as references in
> git commits, use the following tag:
> 
> Link: http://lkml.kernel.org/r/5187EB95.2060605@infradead.org
[...]

http://mid.gmane.org sucks less (most of the time).

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
