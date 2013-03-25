Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3CYKmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:42:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45559 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295Ab3CYKmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:42:13 -0400
Message-ID: <515029FC.3030405@ti.com>
Date: Mon, 25 Mar 2013 12:42:04 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <sameo@linux.intel.com>
CC: Roger Quadros <rogerq@ti.com>, <balbi@ti.com>, <b-cousson@ti.com>,
        <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 0/6] mfd: omap-usb-host: Device tree support for 3.10
References: <1363083940-20050-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1363083940-20050-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

I've rebased this now on top of 3.9-rc4. Please pull this into your
next branch when appropriate. Thanks.

The following changes since commit 8bb9660418e05bb1845ac1a2428444d78e322cc7:

  Linux 3.9-rc4 (2013-03-23 16:52:44 -0700)

are available in the git repository at:
  git://github.com/rogerq/linux.git usbhost-mfd-next

Roger Quadros (5):
      mfd: omap-usb-host: update nports in platform_data
      mfd: omap-usb-host: Remove PHY reset handling code
      mfd: omap-usb-tll: move configuration code to omap_tll_init()
      mfd: omap-usb-tll: Add device tree support and binding information
      mfd: omap-usb-host: Add device tree support and binding information

 .../devicetree/bindings/mfd/omap-usb-host.txt      |   80 ++++++++
 .../devicetree/bindings/mfd/omap-usb-tll.txt       |   17 ++
 drivers/mfd/omap-usb-host.c                        |  200 ++++++++++++++-----
 drivers/mfd/omap-usb-tll.c                         |  214 ++++++++++----------
 drivers/mfd/omap-usb.h                             |    5 +-
 5 files changed, 362 insertions(+), 154 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/omap-usb-host.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/omap-usb-tll.txt

cheers,
-roger

On 03/12/2013 12:25 PM, Roger Quadros wrote:
> Hi Samuel,
> 
> These patches implement device tree support for the OMAP High Speed
> USB Host subsystem. The corresponding EHCI & SoC patches will be sent
> separately and this set has no build dependencies with them.
> 
> Patch 3 is acutally a bug fix which should go into 3.9-rc. I've sent
> it separately to you before.
> 
> The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:
> 
>   Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)
> 
> are available in the git repository at:
>   git://github.com/rogerq/linux.git usbhost-mfd-next
> 
> Roger Quadros (6):
>       mfd: omap-usb-host: update nports in platform_data
>       mfd: omap-usb-host: Remove PHY reset handling code
>       mfd: omap-usb-host: Actually update hostconfig
>       mfd: omap-usb-tll: move configuration code to omap_tll_init()
>       mfd: omap-usb-tll: Add device tree support and binding information
>       mfd: omap-usb-host: Add device tree support and binding information
> 
>  .../devicetree/bindings/mfd/omap-usb-host.txt      |   80 ++++++++
>  .../devicetree/bindings/mfd/omap-usb-tll.txt       |   17 ++
>  drivers/mfd/omap-usb-host.c                        |  206 ++++++++++++++-----
>  drivers/mfd/omap-usb-tll.c                         |  214 ++++++++++----------
>  drivers/mfd/omap-usb.h                             |    5 +-
>  5 files changed, 365 insertions(+), 157 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/omap-usb-host.txt
>  create mode 100644 Documentation/devicetree/bindings/mfd/omap-usb-tll.txt
> 
> --
> cheers,
> -roger
> 

