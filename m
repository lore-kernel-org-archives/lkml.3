Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab3AXQ2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 11:28:17 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59623 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754750Ab3AXQ2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 11:28:16 -0500
Date: Thu, 24 Jan 2013 11:28:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Venu Byravarasu <vbyravarasu@nvidia.com>
cc: gregkh@linuxfoundation.org, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <swarren@wwwdotorg.org>
Subject: Re: [PATCH v2] usb: host: tegra: make use of PHY pointer of HCD
In-Reply-To: <1359023223-13751-1-git-send-email-vbyravarasu@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1301241127490.2163-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2013, Venu Byravarasu wrote:

> As pointer to PHY structure can be stored in struct usb_hcd
> making use of it, to call Tegra PHY APIs.
> 
> Call to usb_phy_shutdown() is moved up in tegra_ehci_remove(),
> so that to avoid dereferencing of hcd after its freed up.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
> First version of patch can be found at
> http://marc.info/?l=linux-kernel&m=135581479020213&w=2. As it was not
> yet applied, sending v2 of the patch.
> 
> delta from v1:
> Modified all Tegra PHY APIs to use standard 'structu usb_phy *' as
> their parameter instead of proprietary parameter of type 'struct tegra_usb_phy *'.

For ehci-tegra.c:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

