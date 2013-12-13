Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab3LMTHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 14:07:12 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:38545 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab3LMTHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 14:07:10 -0500
Date: Fri, 13 Dec 2013 11:07:07 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v4 1/2] ARM: mach-moxart: add MOXA ART SoC platform files
Message-ID: <20131213190707.GA9713@roeck-us.net>
References: <1386945188-8316-1-git-send-email-jonas.jensen@gmail.com>
 <1386945188-8316-2-git-send-email-jonas.jensen@gmail.com>
 <201312131717.25435.arnd@arndb.de>
 <CACmBeS0Uz+Z=MsqvXburO1swCdyGvEXHhfs8M7ZnMMKBNJjG1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACmBeS0Uz+Z=MsqvXburO1swCdyGvEXHhfs8M7ZnMMKBNJjG1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 06:23:44PM +0100, Jonas Jensen wrote:
> On 13 December 2013 17:17, Arnd Bergmann <arnd@arndb.de> wrote:
> > IIRC the separate defconfig is needed because we have never gotten a mixed fa526+arm9
> > kernel to boot, right? In theory it is supposed to work and there is most likely just
> > a small bug somewhere. Once that is working, we can think about adding a generic
> > multi_v4_v5_defconfig that handles all multipltform capable platforms along the lines
> > of multi_v7_defconfig.
> 
> A mixed kernel can boot without panic (tested today).
> 
> The panic is avoided when CONFIG_ARM_THUMB=y is removed.
> 
> See thread "[PATCH] ARM: reinsert ARCH_MULTI_V4 Kconfig option":
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-December/219004.html
> 
> 
> > I've been out of the loop a bit here. I initially suggested having the restart
> > handler be part of the watchdog driver, and I thought you had done that in an
> > earlier version. What has changed your mind?
> 
> I got the impression from Guenter Roeck's review, that it doesn't belong there,
> maybe I was too quick to remove it?
> 
You'd have to answer the questions I raised in my review if you want it in
there.

Guenter

> See thread "[PATCH] watchdog: Add MOXA ART watchdog driver":
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/183065.html
> 
> 
> Thanks,
> Jonas
> 
