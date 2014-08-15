Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaHOPWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:22:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51407 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751027AbaHOPWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:22:15 -0400
Date: Fri, 15 Aug 2014 11:22:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vivek Gautam <gautam.vivek@samsung.com>
cc: linux-usb@vger.kernel.org, <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <grant.likely@linaro.org>,
        <gregkh@linuxfoundation.org>, <jg1.han@samsung.com>,
        <s.nawrocki@samsung.com>, <k.debski@samsung.com>
Subject: Re: [PATCH RFC 6/7] usb: host: ehci-exynos: Remove unnecessary
 usb-phy support
In-Reply-To: <1408026240-28365-7-git-send-email-gautam.vivek@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1408151121580.1144-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2014, Vivek Gautam wrote:

> Now that we have completely moved from older USB-PHY drivers
> to newer GENERIC-PHY drivers for PHYs available with USB controllers
> on Exynos series of SoCs, we can remove the support for the same
> in our host drivers too.
> This should fix the issue on ehci-exynos, wherein in the absence of
> SAMSUNG_USB2PHY config symbol, we ended up getting the NOP_USB_XCEIV phy
> when the same is enabled. And thus the PHYs are not configured properly.
> 
> Reported-by: Sachin Kamat <sachin.kamat@samsung.com>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

