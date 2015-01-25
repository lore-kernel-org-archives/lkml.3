Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbbAYP5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 10:57:21 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:52953 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbbAYP5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 10:57:16 -0500
Date: Sun, 25 Jan 2015 15:56:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: perf not capturing stack traces
Message-ID: <20150125155651.GB11502@n2100.arm.linux.org.uk>
References: <20150123195128.GE26557@saruman.tx.rr.com>
 <20150123205959.GD3073@kernel.org>
 <20150123223745.GJ26557@saruman.tx.rr.com>
 <20150124151204.GF3073@kernel.org>
 <20150124222342.GA26941@saruman.tx.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150124222342.GA26941@saruman.tx.rr.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2015 at 04:23:42PM -0600, Felipe Balbi wrote:
> yeah, I'll try a few older kernels, also see if I can reproduce on other
> boards.

Perf works for me with CONFIG_FRAME_POINTER=y, but that's only for kernel
space, and for userspace where the programs have been built for ARM mode
with frame pointers.

The kernel may work without CONFIG_FRAME_POINTER set, but I've never
tested that, and I'd suggest that (given my experience looking at oops
dumps) it's not all that reliable.

Lastly, userspace without frame pointers is pretty much hopeless.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
