Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbaCDJ1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:27:38 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58322 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410AbaCDJ1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:27:34 -0500
Message-ID: <53159C5E.2040701@ti.com>
Date: Tue, 4 Mar 2014 14:56:54 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <george.cherian@ti.com>,
        <balajitk@ti.com>, <hdegoede@redhat.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 01/12] phy: rename struct omap_control_usb to struct omap_control_phy
References: <1393859254-10937-1-git-send-email-rogerq@ti.com> <1393859254-10937-2-git-send-email-rogerq@ti.com>
In-Reply-To: <1393859254-10937-2-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roger,

On Monday 03 March 2014 08:37 PM, Roger Quadros wrote:
> From: Kishon Vijay Abraham I <kishon@ti.com>
>
> Rename struct omap_control_usb to struct omap_control_phy since it can
> be used to control PHY of USB, SATA and PCIE. Also move the driver and
> include files under *phy* and made the corresponding changes in the users
> of phy-omap-control.
>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>   drivers/phy/Kconfig                  |  14 +-
>   drivers/phy/Makefile                 |   1 +
>   drivers/phy/phy-omap-control.c       | 320 +++++++++++++++++++++++++++++++++++
>   drivers/phy/phy-omap-usb2.c          |   8 +-
>   drivers/phy/phy-ti-pipe3.c           |   8 +-
>   drivers/usb/musb/omap2430.c          |   2 +-
>   drivers/usb/phy/Kconfig              |  10 --
>   drivers/usb/phy/Makefile             |   1 -
>   drivers/usb/phy/phy-omap-control.c   | 319 ----------------------------------
>   include/linux/phy/omap_control_phy.h |  89 ++++++++++
>   include/linux/usb/omap_control_usb.h |  89 ----------
>   11 files changed, 431 insertions(+), 430 deletions(-)
>   create mode 100644 drivers/phy/phy-omap-control.c
>   delete mode 100644 drivers/usb/phy/phy-omap-control.c
>   create mode 100644 include/linux/phy/omap_control_phy.h
>   delete mode 100644 include/linux/usb/omap_control_usb.h

you can use git format-patch -M if a file is moved from one place to 
another. The diff count will be less in that case and reviewing will be 
easier ;-)

Cheers
Kishon
