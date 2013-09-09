Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab3IISqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:46:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3IISqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:46:44 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=zELYHeLyfy0A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=RfjW8z9EBDgA:10 a=8T59DR07AAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=TSbVqHtbAAAA:8 a=bItIiPTFAAAA:8 a=dt3WS_keAAAA:8 a=NgYYbEiGAAAA:8 a=wz9AaHWt85fxyzSumF8A:9 a=CjuIK1q_8ugA:10 a=HEdnscJc8mAA:10 a=U62fhAwekXMA:10 a=SFncbC_4GEwA:10 a=3Rfx1nUSh_UA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 9 Sep 2013 14:46:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Konstantin Ryabitsev <mricon@kernel.org>
Subject: Re: [16/85] b43: ensue that BCMA is "y" when B43 is "y"
Message-ID: <20130909144642.7d61907a@gandalf.local.home>
In-Reply-To: <20130909183904.GJ7729@decadent.org.uk>
References: <lsq.1374674564.753305150@decadent.org.uk>
	<lsq.1374674565.595401652@decadent.org.uk>
	<20130909180115.GC6276@home.goodmis.org>
	<20130909183904.GJ7729@decadent.org.uk>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013 19:39:04 +0100
Ben Hutchings <ben@decadent.org.uk> wrote:

> On Mon, Sep 09, 2013 at 02:01:15PM -0400, Steven Rostedt wrote:
> > On Wed, Jul 24, 2013 at 03:02:45PM +0100, Ben Hutchings wrote:
> > > 3.2.49-rc1 review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Hauke Mehrtens <hauke@hauke-m.de>
> > > 
> > > commit 693026ef2e751fd94d2e6c71028e68343cc875d5 upstream.
> > > 
> > > When b43 gets build into the kernel and it should use bcma we have to
> > > ensure that bcma was also build into the kernel and not as a module.
> > > In this patch this is also done for SSB, although you can not
> > > build b43 without ssb support for now.
> > > 
> > > This fixes a build problem reported by Randy Dunlap in
> > > 5187EB95.2060605@infradead.org
> > 
> > Hauke,
> > 
> > Just an FYI, if you find yourself adding message id's as references in
> > git commits, use the following tag:
> > 
> > Link: http://lkml.kernel.org/r/5187EB95.2060605@infradead.org
> [...]
> 
> http://mid.gmane.org sucks less (most of the time).

Initially, LKML would be archived on kernel.org, but that never
happened and doesn't seem it will after the whole security breach
incident.

But if mid.gname.org is a better link to forward to, then perhaps
Konstantin could update it.

In any case, as I would think kernel.org will be around as long as
Linux is still in use, having the link go to kernel.org, and then
kernel.org could point the result to where ever it liked, is still the
best option.

-- Steve
