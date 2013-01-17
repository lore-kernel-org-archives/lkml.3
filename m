Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3AQPQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:16:45 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:32856 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756071Ab3AQPQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:16:44 -0500
Date: Thu, 17 Jan 2013 10:16:43 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: balbi@ti.com, <sameo@linux.intel.com>, <tony@atomide.com>, <kishon@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux@arm.linux.org.uk>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 01/22] mfd: omap-usb-host: Consolidate OMAP USB-HS
 platform data
In-Reply-To: <1358422231-24736-2-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1301171016090.1339-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013, Roger Quadros wrote:

> Let's have a single platform data structure for the OMAP's High-Speed
> USB host subsystem instead of having 3 separate ones i.e. one for
> board data, one for USB Host (UHH) module and one for USB-TLL module.
> 
> This makes the code much simpler and avoids creating multiple copies of
> platform data.
> 
> CC: Alan Stern <stern@rowland.harvard.edu>
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>

For the ehci-omap.c part:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

