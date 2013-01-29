Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab3A2PaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:30:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36662 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756633Ab3A2PaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:30:06 -0500
Date: Tue, 29 Jan 2013 10:30:05 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: tony@atomide.com, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 10/30] USB: ehci-omap: Use PHY APIs to get the PHY
 device and put it out of suspend
In-Reply-To: <1359453032-20604-1-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1301291026020.1507-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2013, Roger Quadros wrote:

> For each port that is in PHY mode we obtain a PHY device using the USB PHY
> library and put it out of suspend.
> 
> It is up to platform code to associate the PHY to the controller's
> port and it is upto the PHY driver to manage the PHY's resources.

s/upto/up to/

> Also remove wired spacing around declarations we come across.

s/wired/weird/ -- not that people care about misspellings in the 
Changelog.  You don't have to resubmit the patch just to fix these two 
items.

> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

