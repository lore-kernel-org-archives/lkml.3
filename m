Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbaIEKvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:51:41 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45200 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633AbaIEKvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:51:40 -0400
Date: Fri, 5 Sep 2014 12:51:35 +0200
From: Robert Richter <rric@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>
Subject: Re: [PATCH v2 1/4] arm64, thunder: Add Kconfig option for Cavium
 Thunder SoC Family
Message-ID: <20140905105135.GU4703@rric.localhost>
References: <1409903205-2762-1-git-send-email-rric@kernel.org>
 <1409903205-2762-2-git-send-email-rric@kernel.org>
 <20140905083932.GD13515@arm.com>
 <20140905092135.GR4703@rric.localhost>
 <20140905092507.GH13515@arm.com>
 <20140905093647.GH2172@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905093647.GH2172@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.09.14 10:36:47, Mark Rutland wrote:
> On Fri, Sep 05, 2014 at 10:25:08AM +0100, Will Deacon wrote:
> > All I mean is, if the kernel doesn't explode on existing systems by changing
> > the upper limit to 64, then we should do that. If you're not comfortable
> > that the Thunder code can handle that, then leave the thunder default as 32,
> > like you do in the current patch. It just seems odd not to change the
> > maximum number, since it's an arbitrary limit from my perspective.
> 
> FWIW my Juno happily boots with a NR_CPUS=64 kernel.

It looks like if it's fine to set the general default to NR_CPUS=64
even if the kernel might not yet boot more than 32 cpus. Will make
this change separately and drop it in this patch.

See also my other reply to Russell in this thread.

-Robert
