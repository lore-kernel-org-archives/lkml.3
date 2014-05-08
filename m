Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaEHPv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:51:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42701 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752101AbaEHPvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:51:25 -0400
Date: Thu, 8 May 2014 11:51:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 7/8] usb: ohci: sort out dependencies for lpc32xx and
 omap
In-Reply-To: <1399557141-1346645-8-git-send-email-arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1405081151000.1087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Arnd Bergmann wrote:

> The dependency on the isp1301 driver is not something that
> should be in the main OHCI driver but rather the SoC specific
> part of it.
> 
> This moves the dependency for LPC32xx into USB_OHCI_HCD_LPC32XX,
> and changes the 'select ISP1301_OMAP' to a similar 'depends on'.
> Since the same dependency exists for the client driver, do the
> same change there.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-omap@vger.kernel.org
> Cc: Alan Stern <stern@rowland.harvard.edu>

For the host side changes:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

