Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab3DBSnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:43:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54651 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760667Ab3DBSnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:43:46 -0400
Date: Tue, 2 Apr 2013 14:43:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Fainelli <florian@openwrt.org>
cc: linux-kernel@vger.kernel.org, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 5/5 v2] USB: enclose USB_XHCI_HCD related symbols within
 a if USB_XHCI_HCD block
In-Reply-To: <1364922626-32407-6-git-send-email-florian@openwrt.org>
Message-ID: <Pine.LNX.4.44L0.1304021443320.1314-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Florian Fainelli wrote:

> This patch encloses all symbols depending on USB_XHCI_HCD within an if
> USB_XHCI_HCD / endif block.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

