Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab3BKLqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:46:18 -0500
Received: from service87.mimecast.com ([91.220.42.44]:36570 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab3BKLqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:46:16 -0500
Date: Mon, 11 Feb 2013 11:46:11 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Roger Quadros <rogerq@ti.com>
Cc: "tony@atomide.com" <tony@atomide.com>,
        "b-cousson@ti.com" <b-cousson@ti.com>, "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "kishon@ti.com" <kishon@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 07/14] USB: ohci-omap3: Add device tree support and
 binding information
Message-ID: <20130211114611.GB2726@e106331-lin.cambridge.arm.com>
References: <1360252974-7912-1-git-send-email-rogerq@ti.com>
 <1360252974-7912-8-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
In-Reply-To: <1360252974-7912-8-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Feb 2013 11:46:12.0381 (UTC) FILETIME=[6403FCD0:01CE084D]
X-MC-Unique: 113021111461500401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 04:02:47PM +0000, Roger Quadros wrote:
> Allows the OHCI controller found in OMAP3 and later chips to
> be specified via device tree.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> ---
>  .../devicetree/bindings/usb/omap3-ohci.txt         |   17 +++++++++++++++++
>  drivers/usb/host/ohci-omap3.c                      |   19 +++++++++++++++++++
>  2 files changed, 36 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/usb/omap3-ohci.txt
> 
> diff --git a/Documentation/devicetree/bindings/usb/omap3-ohci.txt b/Documentation/devicetree/bindings/usb/omap3-ohci.txt
> new file mode 100644
> index 0000000..ad2ace0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/omap3-ohci.txt
> @@ -0,0 +1,17 @@
> +OMAP HS USB OHCI controller (OMAP3 and later)
> +
> +Required properties:
> +
> +- compatible: should be "ti,ohci-omap3"
> +- reg: should contain one register range i.e. start and length
> +- interrupt-parent: phandle to the interrupt controller

I'm not sure that needs to be documented as a required property. It's a
standard property, and if it's defined for the parent node, you won't need it
here.

Otherwise, this looks fine to me.

Thanks,
Mark.

