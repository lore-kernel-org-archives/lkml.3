Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3ISOZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:25:53 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:48979 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3ISOZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:25:50 -0400
Message-ID: <523B095A.9070006@gmail.com>
Date: Thu, 19 Sep 2013 16:25:30 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: balbi@ti.com, bcousson@baylibre.com, tony@atomide.com,
        devicetree@vger.kernel.org, balajitk@ti.com,
        linux-kernel@vger.kernel.org, kishon@ti.com, linux-ide@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 01/15] phy: rename struct omap_control_usb to struct
 omap_control_phy
References: <1379595943-14622-1-git-send-email-rogerq@ti.com> <1379595943-14622-2-git-send-email-rogerq@ti.com>
In-Reply-To: <1379595943-14622-2-git-send-email-rogerq@ti.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.09.2013 15:05, Roger Quadros wrote:
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
>  drivers/phy/Kconfig                  |   14 ++-
>  drivers/phy/Makefile                 |    1 +
>  drivers/phy/phy-omap-control.c       |  300 ++++++++++++++++++++++++++++++++++
>  drivers/phy/phy-omap-pipe3.c         |    8 +-
>  drivers/phy/phy-omap-usb2.c          |    9 +-
>  drivers/usb/musb/omap2430.c          |    2 +-
>  drivers/usb/phy/Kconfig              |   10 -
>  drivers/usb/phy/Makefile             |    1 -
>  drivers/usb/phy/phy-omap-control.c   |  300 ----------------------------------
>  include/linux/phy/omap_control_phy.h |   83 ++++++++++
>  include/linux/usb/omap_control_usb.h |   83 ----------
>  11 files changed, 406 insertions(+), 405 deletions(-)
>  create mode 100644 drivers/phy/phy-omap-control.c
>  delete mode 100644 drivers/usb/phy/phy-omap-control.c
>  create mode 100644 include/linux/phy/omap_control_phy.h
>  delete mode 100644 include/linux/usb/omap_control_usb.h

In case you do another version of this set, please use "git format-patch
-M", which will detect renames and hence make the review much easier.


Daniel

