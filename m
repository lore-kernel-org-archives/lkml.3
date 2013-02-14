Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934589Ab3BNMOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:14:20 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53671 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933987Ab3BNMOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:14:18 -0500
Message-ID: <511CD513.5030100@ti.com>
Date: Thu, 14 Feb 2013 14:14:11 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>, "Balbi, Felipe" <balbi@ti.com>,
        Roger Quadros <rogerq@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "tony@atomide.com" <tony@atomide.com>, <stable@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] usb: bug fixes for ehci-omap for 3.9
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This pull request contains 2 bug fixes for ehci-omap for 3.9 as well
as older kernels. It is based on 3.8-rc6.

Please pull. Thanks.

The following changes since commit 88b62b915b0b7e25870eb0604ed9a92ba4bfc9f7:

  Linux 3.8-rc6 (2013-02-01 12:08:14 +1100)

are available in the git repository at:
  git://github.com/rogerq/linux.git usbhost17-for-usb

Roger Quadros (2):
      USB: ehci-omap: Don't free gpios that we didn't request
      USB: ehci-omap: Fix autoloading of module

 drivers/usb/host/ehci-omap.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

--
cheers,
-roger
