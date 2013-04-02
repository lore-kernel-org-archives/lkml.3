Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab3DBSmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:42:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54646 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932922Ab3DBSmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:42:37 -0400
Date: Tue, 2 Apr 2013 14:42:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Fainelli <florian@openwrt.org>
cc: linux-kernel@vger.kernel.org, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4/5 v2] USB: enclose all depends on USB_OHCI_HCD within
 an if USB_OHCI_HCD block
In-Reply-To: <1364922626-32407-5-git-send-email-florian@openwrt.org>
Message-ID: <Pine.LNX.4.44L0.1304021441360.1314-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Florian Fainelli wrote:

> This patch removes the various depends on USB_OHCI_HCD from the OHCI HCD
> drivers and enclose them within an if USB_OHCI_HCD / endif block. The
> Octeon OHCI HCD driver has been moved around to remain in this block.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

