Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbaEFP5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:57:10 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37112 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937AbaEFP5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:57:08 -0400
Date: Tue, 6 May 2014 08:57:03 -0700
From: josh@joshtriplett.org
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
Message-ID: <20140506155703.GA20391@cloud>
References: <1399328773-6531-9-git-send-email-andi@firstfloor.org>
 <20140505.231229.136734008603421707.davem@davemloft.net>
 <20140506032114.GP2382@two.firstfloor.org>
 <20140505.232327.578134514220748085.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505.232327.578134514220748085.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 11:23:27PM -0400, David Miller wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Date: Tue, 6 May 2014 05:21:14 +0200
> 
> > What parts would you remove to get the foot print down for a 2MB
> > single purpose machine?
> 
> I wouldn't use Linux, end of story.
> 
> Maybe two decades ago, but not now, those days are over.

That's a self-fulfilling prophecy: if you and others assume that Linux
should not run on such machines, then size regressions will continue to
happen, and patches to make Linux continue running on such systems
will not make it into the kernel.

There are real people and products intending to use Linux on incredibly
tiny embedded systems; Tom already posted about one in this thread.
Personally, I'd much rather see Linux on such systems rather than some
crazy embedded (often proprietary) OS, and so would many other people.
A NAK isn't going to cut it, here; tiny Linux systems are going to
exist, and they shouldn't have to maintain a long-term out-of-tree fork
or use crazy things like LWIP.

I understand that you want to reduce maintenance effort and Kconfig
option proliferation; that's a very real concern.  It's likely possible
to address those concerns while still producing a usable minimal version
of the networking stack, if you'd be willing to provide feedback and
support iteration of patches like these.

Would you be interested in discussing this at Kernel Summit, perhaps?
Would that help to hammer out a plan for this?

- Josh Triplett
