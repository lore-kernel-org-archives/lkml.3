Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab3ARPaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:30:07 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43577 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751554Ab3ARPaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:30:03 -0500
Date: Fri, 18 Jan 2013 10:30:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Venu Byravarasu <vbyravarasu@nvidia.com>
cc: gregkh@linuxfoundation.org, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] usb: Add APIs to access host registers from Tegra
 PHY
In-Reply-To: <1358489737-32273-1-git-send-email-vbyravarasu@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1301181029350.1988-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2013, Venu Byravarasu wrote:

> As Tegra PHY driver needs to access one of the Host registers,
> added few APIs.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
> delta from v2:
> Renamed USB_PORTSC1 to TEGRA_USB_PORTSC1.
> Removed tegra_ehci_set_wakeon_events() and its references.
> Used standard defines for accessing PORTSC fields defined in ehci_def.h
> Included OCC bit of PORTSC as part of TEGRA_PORTSC1_RWC_BITS.
> 
> delta from v1:
> Taken care of RWC bits, while accessing PORTSC register.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

