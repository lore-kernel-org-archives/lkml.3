Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab3BTQbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:31:15 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34765 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750971Ab3BTQbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:31:14 -0500
Date: Wed, 20 Feb 2013 11:31:13 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Manjunath Goudar <manjunath.goudar@linaro.org>
cc: linux-usb@vger.kernel.org, <linux-arm-kernel@lists.infradead.org>,
        <patches@linaro.org>, <arnd@linaro.org>, <gregkh@linuxfoundation.org>,
        Greg KH <greg@kroah.com>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Brian Swetland <swetland@google.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [V2 6/8] USB: EHCI: make ehci-msm a separate driver
In-Reply-To: <1360923853-7875-7-git-send-email-manjunath.goudar@linaro.org>
Message-ID: <Pine.LNX.4.44L0.1302201129280.1671-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2013, Manjunath Goudar wrote:

> Separate the Qualcomm On-Chip host controller driver from ehci-hcd host code
> into its own driver module.

> --- a/drivers/usb/host/ehci-msm.c
> +++ b/drivers/usb/host/ehci-msm.c

> +static const char hcd_name[] = "msm_hsusb_host";

This should be something more like "ehci-msm".  Of course, that means 
you have to leave the ehci_msm_driver.driver.name field unchanged.

Alan Stern

