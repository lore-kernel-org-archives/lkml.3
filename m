Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab3AURQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:16:17 -0500
Received: from netrider.rowland.org ([192.131.102.5]:60645 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752537Ab3AURQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:16:16 -0500
Date: Mon, 21 Jan 2013 12:16:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Thierry Reding <thierry.reding@avionic-design.de>
cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 29/33] usb: Convert to devm_ioremap_resource()
In-Reply-To: <1358762966-20791-30-git-send-email-thierry.reding@avionic-design.de>
Message-ID: <Pine.LNX.4.44L0.1301211215360.19920-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jan 2013, Thierry Reding wrote:

> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org

For the EHCI and OHCI changes:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

