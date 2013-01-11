Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3AKP3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 10:29:00 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34977 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753656Ab3AKP26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 10:28:58 -0500
Date: Fri, 11 Jan 2013 10:28:57 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <sameo@linux.intel.com>, <tony@atomide.com>, <kishon@ti.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/14] usb: ehci-omap: Instantiate PHY devices if required
In-Reply-To: <50EFF075.5090203@ti.com>
Message-ID: <Pine.LNX.4.44L0.1301111019340.1730-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2013, Roger Quadros wrote:

> Alan,
> 
> Thanks for the patch. I've pasted the version that builds and works and
> put you as the Author of the patch, hope it is fine.

As far as I can see, yours is the same as what I posted except that:

	You altered the changes to ehci-hcd.c and Makefile to remove 
	the dependency on the ehci-mxc patch;

	You made an unimportant whitespace change in ehci-omap.c
	(moved a blank line before ehci_write()).

Right?  It's hard to compare the patches directly because the one you 
posted was whitespace-damaged.

Anyway, if this is okay and there's nothing wrong with the ehci-mxc 
change (other than the comment for ehci->priv), I'll submit both of 
them to Greg soon.

Alan Stern

