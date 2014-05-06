Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaEFQlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:41:14 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46158 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaEFQlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:41:13 -0400
Date: Tue, 6 May 2014 09:41:08 -0700
From: josh@joshtriplett.org
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
Message-ID: <20140506164108.GA20536@cloud>
References: <20140506032114.GP2382@two.firstfloor.org>
 <20140505.232327.578134514220748085.davem@davemloft.net>
 <20140506155703.GA20391@cloud>
 <20140506.115941.428706504757835279.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506.115941.428706504757835279.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 11:59:41AM -0400, David Miller wrote:
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

The lowest-end smartphone isn't anywhere close to "dirt cheap", and
hardly counts as "embedded" at all anymore.  Smartphones cost $100+;
we're talking about systems in the low tens of dollars or less.  These
systems will have no graphics, no peripherals, and only one or two
specific functions.  The entirety of their functionality will likely
consist of a single userspace program; they might not even have a PID 2.
*That's* the kind of "embedded" we're talking about, not the
supercomputers we carry around in our pockets.

Every KB of RAM costs real money and SoC die area (for eDRAM/eSRAM).
Look at how much cache low-end processors have, and imagine running
entirely out of *that*.  Let's not surrender that entire class of
devices to VxWorks, FreeRTOS, and other painfully non-Linux systems,
when we already know it's possible to run Linux on them successfully.

- Josh Triplett
