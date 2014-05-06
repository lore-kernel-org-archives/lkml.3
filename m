Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbaEFWuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 18:50:44 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41189 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbaEFWun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 18:50:43 -0400
Date: Tue, 6 May 2014 15:50:39 -0700
From: josh@joshtriplett.org
To: David Miller <davem@davemloft.net>
Cc: xiyou.wangcong@gmail.com, andi@firstfloor.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com,
        ak@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
Message-ID: <20140506225039.GA22331@cloud>
References: <CAM_iQpUgj7BqpzRL070DEGQ32SWwN68BRgM5DtFqvBLjGGOLQA@mail.gmail.com>
 <20140506.164410.15377655213427639.davem@davemloft.net>
 <20140506210815.GB21791@cloud>
 <20140506.171117.1365037653422161013.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506.171117.1365037653422161013.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 05:11:17PM -0400, David Miller wrote:
> From: josh@joshtriplett.org
> Date: Tue, 6 May 2014 14:08:15 -0700
> 
> > On Tue, May 06, 2014 at 04:44:10PM -0400, David Miller wrote:
> >> From: Cong Wang <xiyou.wangcong@gmail.com>
> >> Date: Tue, 6 May 2014 11:33:11 -0700
> >> 
> >> > So why bothers 3.15+ Linux kernel? Why not use an old kernel e.g. 2.4.x?
> >> > 2.4.x kernel doesn't have so many new features you want to get rid of here.
> >> 
> >> +1
> > 
> > You've got to be kidding.  Using 2.4 for a new network-connected device,
> > today?  With all of its potential security holes that nobody is paying
> > attention to?  Easier to fork 3.15 and trim it down than to do *that*.
> > And there *are* a huge number of useful features in 3.15+, not least of
> > which drivers for current hardware.
> 
> So you're saying that the 2.4.x -stable maintainer did a shitty job and
> his work is worthless?

There's a difference between maintaining 2.4.x for all the existing
users who can't or won't upgrade, and introducing a *new* product
shipping with 2.4.x.  There's something very wrong if 2.4.x works for
cases that 3.x doesn't; that would be a serious regression.

- Josh Triplett
