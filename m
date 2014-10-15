Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592AbaJOCSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 22:18:07 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:9899 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbaJOCSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 22:18:05 -0400
X-IronPort-AV: E=Sophos;i="5.04,720,1406617200"; 
   d="scan'208";a="48224470"
Message-ID: <543DD959.2060801@broadcom.com>
Date: Tue, 14 Oct 2014 19:18:01 -0700
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>
Subject: get_maintainers.pl doesn't actually get the real MAINTAINERS?
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I try running scripts/get_maintainers.pl but it doesn't seem to get the 
real maintainers properly.  Please note this is run against the current 
MAINTAINERS file.

One Example:  I would expect drivers/mmc/host/sdhci-bcm2835.c to be 
maintained by Stephen Warren based on drivers/*/*bcm2835* below.  But 
the get_maintainers.pl script does not seem to process the information 
in such a way.  So what needs to be corrected - the script or the syntax 
used in the MAINTAINERS file?

BROADCOM BCM2835 ARM ARCHICTURE
M:	Stephen Warren <swarren@wwwdotorg.org>
L:	linux-rpi-kernel@lists.infradead.org (moderated for non-subscribers)
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-rpi.git
S:	Maintained
F:	arch/arm/mach-bcm/board_bcm2835.c
F:	arch/arm/boot/dts/bcm2835*
F:	arch/arm/configs/bcm2835_defconfig
F:	drivers/*/*bcm2835*

Regards,
Scott
