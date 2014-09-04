Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaIDVw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:52:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068AbaIDVw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:52:56 -0400
Date: Thu, 4 Sep 2014 14:52:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, falcon@meizu.com,
        tiwai@suse.de, tj@kernel.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, akpm@linux-foundation.org,
        penguin-kernel@i-love.sakura.ne.jp, joseph.salisbury@canonical.com,
        bpoirier@suse.de, Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
Message-ID: <20140904215211.GB738@kroah.com>
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
 <540334B2.7000009@linux.intel.com>
 <20140831175040.GA17827@core.coreip.homeip.net>
 <5403767E.1020107@linux.intel.com>
 <20140831193140.GA12678@kroah.com>
 <20140831201407.GB19881@core.coreip.homeip.net>
 <20140831204035.GA4793@kroah.com>
 <20140904212118.GB3347@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140904212118.GB3347@wotan.suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 11:21:18PM +0200, Luis R. Rodriguez wrote:
> I still believe its a good approach if we wanted to scale it but that
> would require the desire to do so, I obviously considered it worthwhile
> as I shaved off at least ~1 second off kernel boot time when doing an
> original proof of concept and only doing drivers, and taking into
> consideration my kenrel takes ~5 seconds before userspace is reached.

Sidenote, something is really wrong with your hardware or configuration
if it takes 5 seconds to get to userspace on a modern system these days.
Everything[1] I run is in the sub-second boot time before userspace is
hit, and everything boots to full graphics mode in less than 5 seconds.
The long-pole is by far, the bios/uefi these days.

I think you need new hardware, or a better kernel .config file :)

> I'll toss this in the bin for now though and send something based on
> Tejun's approach shortly!

That would be great, thanks for doing this.

greg k-h

[1] A wide range of laptops and server/build boxes, some 3+ years old,
this isn't just new hardware by any means.
