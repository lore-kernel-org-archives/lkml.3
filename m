Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934303Ab3BNMBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:01:32 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53277 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab3BNMBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:01:31 -0500
Message-ID: <511CD215.8080005@ti.com>
Date: Thu, 14 Feb 2013 14:01:25 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "tony@atomide.com" <tony@atomide.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "Balbi, Felipe" <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [GIT PULL] common: OMAP USB Host cleanup for 3.9
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony & Samuel,

This is the common patch for the OMAP USB Host cleanup series for 3.9.
It makes changes to platform headers only.
The other 2 pull requests, one for each of you will be based on this.

This is based on 3.8-rc6.

Please pull. Thanks.

The following changes since commit 88b62b915b0b7e25870eb0604ed9a92ba4bfc9f7:

  Linux 3.8-rc6 (2013-02-01 12:08:14 +1100)

are available in the git repository at:
  git://github.com/rogerq/linux.git usbhost17-common

Roger Quadros (1):
      ARM: OMAP: Consolidate OMAP USB-HS platform data (part 1/3)

 include/linux/platform_data/usb-omap.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

--
cheers,
-roger
