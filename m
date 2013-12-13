Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab3LMRXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:23:46 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:50161 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab3LMRXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:23:45 -0500
MIME-Version: 1.0
In-Reply-To: <201312131717.25435.arnd@arndb.de>
References: <1386945188-8316-1-git-send-email-jonas.jensen@gmail.com>
	<1386945188-8316-2-git-send-email-jonas.jensen@gmail.com>
	<201312131717.25435.arnd@arndb.de>
Date: Fri, 13 Dec 2013 18:23:44 +0100
Message-ID: <CACmBeS0Uz+Z=MsqvXburO1swCdyGvEXHhfs8M7ZnMMKBNJjG1A@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: mach-moxart: add MOXA ART SoC platform files
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>,
        "linux@roeck-us.net" <linux@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 December 2013 17:17, Arnd Bergmann <arnd@arndb.de> wrote:
> IIRC the separate defconfig is needed because we have never gotten a mixed fa526+arm9
> kernel to boot, right? In theory it is supposed to work and there is most likely just
> a small bug somewhere. Once that is working, we can think about adding a generic
> multi_v4_v5_defconfig that handles all multipltform capable platforms along the lines
> of multi_v7_defconfig.

A mixed kernel can boot without panic (tested today).

The panic is avoided when CONFIG_ARM_THUMB=y is removed.

See thread "[PATCH] ARM: reinsert ARCH_MULTI_V4 Kconfig option":

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-December/219004.html


> I've been out of the loop a bit here. I initially suggested having the restart
> handler be part of the watchdog driver, and I thought you had done that in an
> earlier version. What has changed your mind?

I got the impression from Guenter Roeck's review, that it doesn't belong there,
maybe I was too quick to remove it?

See thread "[PATCH] watchdog: Add MOXA ART watchdog driver":

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/183065.html


Thanks,
Jonas
