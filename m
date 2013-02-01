Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab3BAKZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:25:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59359 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab3BAKZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:25:47 -0500
Date: Fri, 1 Feb 2013 11:25:46 +0100
From: Pavel Machek <pavel@denx.de>
To: Phil Turmel <philip@turmel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: paul.szabo@sydney.edu.au, ben@decadent.org.uk, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: PAE problems was [RFC] Reproducible OOM with just a few sleeps
Message-ID: <20130201102545.GA3053@amd.pavel.ucw.cz>
References: <201302010313.r113DTj3027195@como.maths.usyd.edu.au>
 <510B46C3.5040505@turmel.org>
 <20130201102044.GA2801@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130201102044.GA2801@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri 2013-02-01 11:20:44, Pavel Machek wrote:
> On Thu 2013-01-31 23:38:27, Phil Turmel wrote:
> > On 01/31/2013 10:13 PM, paul.szabo@sydney.edu.au wrote:
> > > [trim /] Does not that prove that PAE is broken?
> > 
> > Please, Paul, take *yes* for an answer.  It is broken.  You've received
> > multiple dissertations on why it is going to stay that way.  Unless you
> > fix it yourself, and everyone seems to be politely wishing you the best
> > of luck with that.
> 
> It is not Paul's job to fix PAE. It is job of whoever broke it to do
> so.
> 
> If it is broken with 2GB of RAM, it is clearly not the known "lowmem
> starvation" issue, it is something else... and probably worth
> debugging.
> 
> So, Paul, if you have time and interest... Try to find some old kernel
> version where sleep test works with PAE. Hopefully there is one. Then
> do bisection... author of the patch should then fix it. (And if not,
> at least you have patch you can revert.)
> 
> rjw is worth cc-ing at that point.

Ouch, and... IIRC (hpa should know for sure), PAE is neccessary for
R^X support on x86, thus getting more common, not less. If it does not
work, that's bad news.

Actually, if PAE is known broken, it should probably get marked as
such in Kconfig. That's sure to get some discussion started...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
