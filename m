Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab3GZMOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:14:55 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:48817 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab3GZMOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:14:52 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+QRJBPZMHUJn/skevHcxrI+8Jb6XjXwYw=
Date: Fri, 26 Jul 2013 08:14:38 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Domenico Andreoli <cavokz@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130726121438.GF29916@titan.lakedaemon.net>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <CAL_JsqJQWOLC9f1igEpsgJB2X8mFDpqLDaFFRjGGVHctjWZLgQ@mail.gmail.com>
 <20130725193135.GT23879@titan.lakedaemon.net>
 <CAL_Jsq+vWbTb8wNEDCR2c_M6sBnKW6e5HGk48QzmXSujQUdddA@mail.gmail.com>
 <20130725203228.GX23879@titan.lakedaemon.net>
 <20130725215315.GV7729@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725215315.GV7729@decadent.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 10:53:15PM +0100, Ben Hutchings wrote:
> On Thu, Jul 25, 2013 at 04:32:28PM -0400, Jason Cooper wrote:
> [...]
> > One of the things I've been trying to square up in my head is how to
> > retain the history of the binding when moving to the new tree.  My
> > current idea was to clone the kernel tree, add one patch deleting
> > everything but the bindings and dts files, and one more patch moving
> > things where we want them (arch/{powerpc,arm}/boot/dts -> dts).
> > 
> > Then, as needed, we could merge a kernel version tag and delete
> > everything we don't need (code) in the merge commit.
> > 
> > The downside of this is it would be messy, the upside is that we could
> > closely track the kernel tree (until the bindings and dts are moved
> > out), and retain the history of the bindings and dts files.
> [...]
> 
> It's *extremely* messy, but 'git filter-branch' might help to make a
> clean tracking branch preserving history of just DT files.  David
> Woodhouse did something like that for the linux-firmware repo
> initially.

ok, but once that is setup, asking patch submitters to keep binding doc
and dts file changes in separate patches from code changes would allow
us to put those patches in a separate branch, mergable into both trees.

thx,

Jason.
