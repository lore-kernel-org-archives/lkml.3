Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbaEIJsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:48:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46676 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaEIJsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:48:22 -0400
Date: Fri, 9 May 2014 11:48:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Miller <davem@davemloft.net>
Cc: josh@joshtriplett.org, andi@firstfloor.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com,
        ak@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
Message-ID: <20140509094813.GC4877@xo-6d-61-c0.localdomain>
References: <20140506032114.GP2382@two.firstfloor.org>
 <20140505.232327.578134514220748085.davem@davemloft.net>
 <20140506155703.GA20391@cloud>
 <20140506.115941.428706504757835279.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506.115941.428706504757835279.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-05-06 11:59:41, David Miller wrote:
> From: josh@joshtriplett.org
> Date: Tue, 6 May 2014 08:57:03 -0700
> 
> > On Mon, May 05, 2014 at 11:23:27PM -0400, David Miller wrote:
> >> From: Andi Kleen <andi@firstfloor.org>
> >> Date: Tue, 6 May 2014 05:21:14 +0200
> >> 
> >> > What parts would you remove to get the foot print down for a 2MB
> >> > single purpose machine?
> >> 
> >> I wouldn't use Linux, end of story.
> >> 
> >> Maybe two decades ago, but not now, those days are over.
> > 
> > That's a self-fulfilling prophecy:
> 
> Making 2MB RAM machines today makes no sense at all.
> 
> The lowest end dirt cheap smartphone, something which fits on
> someone's pocket, has gigabytes of ram.

Low end smartphone is quite high-end device :-). It only has to run for
few days on big battery.

I have programmable watch with <64K RAM. Yes, that one runs for months on
battery. 

> The only entity looking backwards are the people making these
> improperly provisioned systems.

There's nothing improper about small ammount of RAM to save power.

									Pavel



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
