Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab3GYVx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 17:53:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50795 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754001Ab3GYVx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 17:53:26 -0400
Date: Thu, 25 Jul 2013 22:53:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Jason Cooper <jason@lakedaemon.net>
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
Message-ID: <20130725215315.GV7729@decadent.org.uk>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <CAL_JsqJQWOLC9f1igEpsgJB2X8mFDpqLDaFFRjGGVHctjWZLgQ@mail.gmail.com>
 <20130725193135.GT23879@titan.lakedaemon.net>
 <CAL_Jsq+vWbTb8wNEDCR2c_M6sBnKW6e5HGk48QzmXSujQUdddA@mail.gmail.com>
 <20130725203228.GX23879@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725203228.GX23879@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 04:32:28PM -0400, Jason Cooper wrote:
[...]
> One of the things I've been trying to square up in my head is how to
> retain the history of the binding when moving to the new tree.  My
> current idea was to clone the kernel tree, add one patch deleting
> everything but the bindings and dts files, and one more patch moving
> things where we want them (arch/{powerpc,arm}/boot/dts -> dts).
> 
> Then, as needed, we could merge a kernel version tag and delete
> everything we don't need (code) in the merge commit.
> 
> The downside of this is it would be messy, the upside is that we could
> closely track the kernel tree (until the bindings and dts are moved
> out), and retain the history of the bindings and dts files.
[...]

It's *extremely* messy, but 'git filter-branch' might help to make a
clean tracking branch preserving history of just DT files.  David
Woodhouse did something like that for the linux-firmware repo
initially.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
