Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab3GFSSP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 14:18:15 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:46484 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933Ab3GFSSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 14:18:14 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Jul 2013 14:18:14 EDT
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@infradead.org,
        arm@kernel.org, Imre Kaloz <kaloz@openwrt.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 7/8] ARM: ixp4xx: avoid circular header dependency
References: <1373041417-217728-1-git-send-email-arnd@arndb.de>
	<1373041417-217728-8-git-send-email-arnd@arndb.de>
Date: Sat, 06 Jul 2013 20:11:17 +0200
In-Reply-To: <1373041417-217728-8-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Fri, 5 Jul 2013 18:23:36 +0200")
Message-ID: <m37gh336ey.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> With the new linux/reboot.h header file dependency added, we can no
> longer build ixp4xx. The easiest way to avoid that is to remove the
> inclusion of mach/hardware.h from mach/timex.h, which does not need
> that header anyway.

>  arch/arm/mach-ixp4xx/include/mach/timex.h | 2 +-

Acked-by: Krzysztof Halasa <khc@pm.waw.pl>
-- 
Krzysztof Halasa
