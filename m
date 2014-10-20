Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaJTXpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 19:45:45 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:57366 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaJTXpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:45:44 -0400
Date: Mon, 20 Oct 2014 16:45:39 -0700
From: josh@joshtriplett.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Aristeu Rozanski <aris@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tiny: reverse logic for DISABLE_DEV_COREDUMP
Message-ID: <20141020234539.GF8929@cloud>
References: <20141016133658.GP5930@redhat.com>
 <20141016134430.GB7664@thin>
 <20141016154949.GR5930@redhat.com>
 <1413798151.10246.10.camel@jlt4.sipsolutions.net>
 <20141020115511.GA28133@thin>
 <20141020221800.GB2101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020221800.GB2101@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 06:18:00AM +0800, Greg Kroah-Hartman wrote:
> On Mon, Oct 20, 2014 at 04:55:11AM -0700, Josh Triplett wrote:
> > On Mon, Oct 20, 2014 at 11:42:31AM +0200, Johannes Berg wrote:
> > > On Thu, 2014-10-16 at 11:49 -0400, Aristeu Rozanski wrote:
> > > > It's desirable for allnconfig and tinyconfig targets to result in the
> > > > least amount of code possible. DISABLE_DEV_COREDUMP exists as a way to
> > > > switch off DEV_COREDUMP regardless if any drivers select
> > > > WANT_DEV_COREDUMP.
> > > > 
> > > > This patch renames the option to ENABLE_DEV_COREDUMP and setting it to
> > > > 'n' (as in allnconfig or tinyconfig) will effectively disable device
> > > > coredump.
> > > > 
> > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Cc: Josh Triplett <josh@joshtriplett.org>
> > > > Cc: Johannes Berg <johannes@sipsolutions.net>
> > > 
> > > Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> > > Acked-by: Johannes Berg <johannes@sipsolutions.net>
> > > 
> > > Yeah, looks sensible, and should work.
> > 
> > Thanks.
> > 
> > I've added this to the tiny/reverse-dev-coredump branch of my
> > tinification tree at
> > https://git.kernel.org/cgit/linux/kernel/git/josh/linux.git/ , with
> > Johannes' review, and I'll push it upstream during the 3.19 merge
> > window.
> 
> I'll take it through the same tree this original came in and will get it
> into 3.18 so we don't confuse anyone with an odd config option.

Excellent, dropped from tiny then.

- Josh Triplett
