Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab3CMOaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:30:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33351 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932391Ab3CMOaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:30:16 -0400
Date: Wed, 13 Mar 2013 10:30:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: gregkh@linuxfoundation.org, <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <kishon@ti.com>
Subject: Re: [PATCH v3 12/13] USB: ehci-omap: Fix detection in HSIC mode
In-Reply-To: <1363180483-10612-1-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1303131029590.1705-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Mar 2013, Roger Quadros wrote:

> Move PHY initialization until after EHCI initialization is
> complete, instead of initializing the PHYs first, shutting
> them down again, and then initializing them a second time.
> 
> This fixes HSIC device detection.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> CC: Alan Stern <stern@rowland.harvard.edu>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

