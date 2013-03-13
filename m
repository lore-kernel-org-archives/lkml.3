Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345Ab3CMOcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:32:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33364 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756420Ab3CMOcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:32:17 -0400
Date: Wed, 13 Mar 2013 10:32:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: gregkh@linuxfoundation.org, <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <kishon@ti.com>
Subject: Re: [PATCH 13/13] USB: ehci-omap: Get rid of omap_ehci_init()
In-Reply-To: <1363180563-10658-1-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1303131032020.1705-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Mar 2013, Roger Quadros wrote:

> As it does almost nothing, get rid of omap_ehci_init()
> and move the ehci->caps initialization part into probe().
> 
> Also remove the outdated TODO list from header.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> CC: Alan Stern <stern@rowland.harvard.edu>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

