Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaIEGz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:55:26 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:55844 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaIEGzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:55:24 -0400
Date: Fri, 5 Sep 2014 08:55:19 +0200
From: Robert Richter <rric@kernel.org>
To: Olof Johansson <olof@lixom.net>
Cc: Robert Richter <rrichter@cavium.com>, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] arm64, dts: Add dtbs_install make target
Message-ID: <20140905065519.GQ4703@rric.localhost>
References: <1406732794-20920-1-git-send-email-rric@kernel.org>
 <1406732794-20920-3-git-send-email-rric@kernel.org>
 <CAOesGMh9KkdKB_ytJ7CCbkPW7dHTX91NdfDMsMNfbmOBVOJ8PQ@mail.gmail.com>
 <20140828161556.GN4703@rric.localhost>
 <20140828162549.GP14650@leverpostej>
 <CAOesGMjtjcgUNV8WLp6_Zbok-0zq5afg_KS8QJYp=kDVabrQvg@mail.gmail.com>
 <20140828181429.GO4703@rric.localhost>
 <CAOesGMh3TEKZkyPjopfSm07C2ydw5=2VrzY0xQ=9jkhoA-Z_kQ@mail.gmail.com>
 <20140829121023.GW13038@rric.localhost>
 <20140829134942.GP4703@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140829134942.GP4703@rric.localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof,

On 29.08.14 15:49:42, Robert Richter wrote:
> On 29.08.14 14:10:23, Robert Richter wrote:
> > On 28.08.14 16:01:08, Olof Johansson wrote:
> > > Thinking about it a bit more, the even more obvious solution that I
> > > for some reason didn't think of at the time, is to have the
> > > dtbs_install target create the appropriate subdirectories on the
> > > install side, so that the structure is preserved.
> > > 
> > > That comes a bit closer to how modules are handled as well.
> > 
> > Yes, dtbs_install target would be useful.
> > 
> > Will come with a solution for this too.
> 
> below is a patch that adds the dtbs_install target to arm64. Taken
> from arm where this was already implemented.

please note that I sent a separate patch set with a complete
implementation of this with the title:

 [PATCH 0/6] dts, kbuild: Implement support for dtb vendor subdirs

this patch is included there too.

-Robert
