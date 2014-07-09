Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbaGIOIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:08:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48984 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755679AbaGIOIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:08:07 -0400
Date: Wed, 9 Jul 2014 10:08:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Bresticker <abrestic@chromium.org>
cc: Julius Werner <jwerner@chromium.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v1 6/9] usb: xhci: Add NVIDIA Tegra XHCI host-controller
 driver
In-Reply-To: <CAL1qeaHT8Yz7kRY3Qm5i+bYCF4D5BT=BVZ6BMfQufyaQFkt0mw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1407091001150.873-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2014, Andrew Bresticker wrote:

> > I think at the very least you should add a function
> > "xhci_default_driver(struct hc_driver *driver)" to xhci-plat.c (or
> > even better to xhci.c and use it for PCI as well) that initializes all
> > function pointers to the default (internal) symbols, and can then be
> > overridden afterwards.
> 
> Currently all XHCI host drivers (PCI, platform, MVEBU) will be built
> into the xhci-hcd module.  I could append the Tegra driver to that
> module or introduce a xhci_init_driver() like EHCI does as Julius
> suggests.  USB folks, do you have a preference?

As the EHCI maintainer, I naturally approve of Julius's suggestion.  

Alan Stern

