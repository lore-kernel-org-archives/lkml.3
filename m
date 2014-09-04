Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbaIDVO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:14:27 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52212 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbaIDVOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:14:23 -0400
Date: Thu, 4 Sep 2014 14:14:19 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [stable -3.14] PM backports for pm_test / CONFIG_PM_DEBUG
Message-ID: <20140904211419.GC18411@ld-irv-0074>
References: <20140904010219.GA18411@ld-irv-0074>
 <1849024.CHOUso6H2K@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1849024.CHOUso6H2K@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 09:40:41PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, September 03, 2014 06:02:19 PM Brian Norris wrote:
> > I think I've narrowed it down to this commit that should be backported
> > to -stable (for 3.9+?):
> > 
> >     43e8317b0bba PM / sleep: Use valid_state() for platform-dependent sleep states only
> > 
> > But it needs to drag along this dependency too:
> > 
> >     27ddcc6596e5 PM / sleep: Add state field to pm_states[] entries
> 
> That sounds OK.
> 
> Can you please send a formal request to include the two commits above to Greg/stable?

Sure. I've never done a post-merge -stable request; the format isn't
100% clear, but I'll give it a go.

> > While at this, it looks like this commit might be deserving of -stable
> > (3.9+). I haven't tested this one, as I don't have a good freeze+cpuidle
> > setup; it just shows up in the commit log with an interesting
> > description and a 'Fixes' tag:
> > 
> >     f3f125324fc1 PM / suspend: Make cpuidle work in the "freeze" state
> 
> Well, it basically makes the freeze state save energy, but it's not essential.
> 
> I'm not seeing the "Fixes:" tag on it, though.

Oops, I must have been looking at a different commit. Sorry!

Brian
