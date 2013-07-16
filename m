Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab3GPFxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 01:53:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33564 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab3GPFxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 01:53:18 -0400
Message-ID: <51E4DFA6.2010501@ti.com>
Date: Tue, 16 Jul 2013 11:22:38 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <tony@atomide.com>, <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <linux@arm.linux.org.uk>, <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] usb: musb: fix USB enumeration issue in OMAP3
 platform
References: <1373282057-20181-1-git-send-email-kishon@ti.com>
In-Reply-To: <1373282057-20181-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony,

On Monday 08 July 2013 04:44 PM, Kishon Vijay Abraham I wrote:
> This series fixes the USB enumeration issue caused because of the controller
> not able to get a reference to the PHY because of incorrect binding in the
> board file.
> 
> In the case of non-dt boot, the platform specific initialization file
> (board file) will do usb_bind_phy that binds the usb controller with the
> PHY using device names. After the device names are created using 
> PLATFORM_DEVID_AUTO, our original method of binding by device names doesn't
> work reliably (since the device name changes). Hence the usb controller
> is made to use labels for getting the PHY.
> 
> Here the PHY name is added in the plat data of USB controller device which
> should be used by the controller driver to get the PHY.
> Two new APIs usb_get_phy_by_name and devm_usb_get_phy_by_name are added to
> be used by the controller to get the PHY by name.

You haven't picked this patch series?

-Kishon
