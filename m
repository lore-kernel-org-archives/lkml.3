Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934546Ab3BNMEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:04:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34864 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934196Ab3BNMEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:04:36 -0500
Message-ID: <511CD2CE.2020802@ti.com>
Date: Thu, 14 Feb 2013 14:04:30 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "tony@atomide.com" <tony@atomide.com>
CC: Roger Quadros <rogerq@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Balbi, Felipe" <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arm-soc: OMAP USB Host cleanup for 3.9
References: <511CD215.8080005@ti.com>
In-Reply-To: <511CD215.8080005@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

This is the ARM-soc part of the OMAP USB Host cleanup series for 3.9.
It is based on 3.8-rc6 + usbhost17-common that I sent earlier.

Please pull. Thanks.

The following changes since commit 7f07863ec60f7d3dbeec5aff881ea074db3925ed:

  ARM: OMAP: Consolidate OMAP USB-HS platform data (part 1/3) (2013-02-13 13:22:34 +0200)

are available in the git repository at:
  git://github.com/rogerq/linux.git usbhost17-for-arm-soc

Roger Quadros (1):
      ARM: OMAP: Consolidate OMAP USB-HS platform data (part 3/3)

 arch/arm/mach-omap2/board-3430sdp.c        |    2 +-
 arch/arm/mach-omap2/board-3630sdp.c        |    2 +-
 arch/arm/mach-omap2/board-am3517crane.c    |    2 +-
 arch/arm/mach-omap2/board-am3517evm.c      |    2 +-
 arch/arm/mach-omap2/board-cm-t35.c         |    2 +-
 arch/arm/mach-omap2/board-cm-t3517.c       |    2 +-
 arch/arm/mach-omap2/board-devkit8000.c     |    2 +-
 arch/arm/mach-omap2/board-igep0020.c       |    4 +-
 arch/arm/mach-omap2/board-omap3beagle.c    |    2 +-
 arch/arm/mach-omap2/board-omap3evm.c       |    2 +-
 arch/arm/mach-omap2/board-omap3pandora.c   |    2 +-
 arch/arm/mach-omap2/board-omap3stalker.c   |    2 +-
 arch/arm/mach-omap2/board-omap3touchbook.c |    2 +-
 arch/arm/mach-omap2/board-omap4panda.c     |    2 +-
 arch/arm/mach-omap2/board-overo.c          |    2 +-
 arch/arm/mach-omap2/board-zoom.c           |    2 +-
 arch/arm/mach-omap2/usb-host.c             |   29 ++++-----------------------
 arch/arm/mach-omap2/usb.h                  |   20 +------------------
 18 files changed, 23 insertions(+), 60 deletions(-)

--
cheers,
-roger
