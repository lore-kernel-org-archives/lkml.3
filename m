Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbaBUPee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:34:34 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42568 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932278AbaBUPe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:34:29 -0500
Date: Fri, 21 Feb 2014 10:34:28 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alistair Popple <alistair@popple.id.au>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 3/7] IBM Akebono: Add support to the OHCI platform driver
 for PPC476GTR
In-Reply-To: <1392964293-13687-4-git-send-email-alistair@popple.id.au>
Message-ID: <Pine.LNX.4.44L0.1402211032080.1273-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014, Alistair Popple wrote:

> The IBM Akebono board uses the PPC476GTR SoC which has a OHCI
> compliant USB host interface. This patch adds support for it to the
> OHCI platform driver.
> 
> As we use device tree to pass platform specific data instead of
> platform data we remove the check for platform data and instead
> provide reasonable defaults if no platform data is present. This is
> similar to what is currently done in ehci-platform.c.
> 
> Signed-off-by: Alistair Popple <alistair@popple.id.au>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

As Arnd pointed out, this patch is out of date.  See

https://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git/commit/drivers/usb/host/ohci-platform.c?h=usb-next&id=ca52a17ba975dbf47e87c9bc63086aca0cf92806

and

https://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git/commit/drivers/usb/host/ohci-platform.c?h=usb-next&id=ce149c30b9f89d0c9addd1d71ccdb57c1051553b

Alan Stern

