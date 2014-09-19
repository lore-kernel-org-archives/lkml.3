Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbaISMbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 08:31:04 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:59846 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbaISMbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 08:31:02 -0400
Date: Fri, 19 Sep 2014 14:30:56 +0200
From: Robert Richter <rric@kernel.org>
To: Andrew Bresticker <abrestic@google.com>
Cc: Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Michal Marek <mmarek@suse.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kbuild@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>
Subject: Re: [PATCH 0/6] dts, kbuild: Implement support for dtb vendor subdirs
Message-ID: <20140919123056.GC20170@rric.localhost>
References: <1409899692-1455-1-git-send-email-rric@kernel.org>
 <CAL1qeaGCeRyeKLo70E264bZcamOfBKoN9Y8_NDCjV5j4DoOw1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1qeaGCeRyeKLo70E264bZcamOfBKoN9Y8_NDCjV5j4DoOw1Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.09.14 20:49:18, Andrew Bresticker wrote:

> > Robert Richter (6):
> >   dts, arm64: Add dtbs_install make target
> >   dts, kbuild: Factor out dtbs install rules to Makefile.dtbinst
> >   dts, arm/arm64: Remove dtbs build rules in sub-makes
> >   dts, kbuild: Implement support for dtb vendor subdirs
> >   dts, arm64: Move dts files to vendor subdirs
> >   dts, arm: Remove $(MACHINE) variable from dtbs make recipes
> 
> I've tested this for arm64 and by adding a vendor sub-directory
> locally for arm.  This series is also the base for my MIPS DT vendor
> sub-directory series
> (http://www.linux-mips.org/archives/linux-mips/2014-09/msg00217.html).
> So, for the entire series,
> 
> Tested-by: Andrew Bresticker <abrestic@chromium.org>

Andrew, thanks for testing and great this also works on mips.

Anyone willing to take the patches for 3.18? Are any further acks
needed?

Thanks,

-Robert
