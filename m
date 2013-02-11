Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab3BKLw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:52:26 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50950 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab3BKLwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:52:24 -0500
Date: Mon, 11 Feb 2013 11:52:19 +0000
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
Subject: Re: [PATCH v2 08/14] USB: ehci-omap: Add device tree support and
 binding information
Message-ID: <20130211115219.GC2726@e106331-lin.cambridge.arm.com>
References: <1360252974-7912-1-git-send-email-rogerq@ti.com>
 <1360252974-7912-9-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
In-Reply-To: <1360252974-7912-9-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Feb 2013 11:52:19.0939 (UTC) FILETIME=[3F18E330:01CE084E]
X-MC-Unique: 113021111522221301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 04:02:48PM +0000, Roger Quadros wrote:
> Allows the OMAP EHCI controller to be specified via device tree.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> ---
>  .../devicetree/bindings/usb/omap-ehci.txt          |   34 ++++++++++++++++++
>  drivers/usb/host/ehci-omap.c                       |   36 +++++++++++++++++++-
>  2 files changed, 69 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/usb/omap-ehci.txt
> 
> diff --git a/Documentation/devicetree/bindings/usb/omap-ehci.txt b/Documentation/devicetree/bindings/usb/omap-ehci.txt
> new file mode 100644
> index 0000000..b00a654
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/omap-ehci.txt
> @@ -0,0 +1,34 @@
> +OMAP HS USB EHCI controller
> +
> +This device is usually the child of the omap-usb-host
> +Documentation/devicetree/bindings/mfd/omap-usb-host.txt
> +
> +Required properties:
> +
> +- compatible: should be "ti,ehci-omap"
> +- reg: should contain one register range i.e. start and length
> +- interrupt-parent: phandle to the interrupt controller

Same comment as for ohci-omap3 here; I don't think it's necessary to document
this as a required property.

Otherwise, looks good.

Thanks,
Mark.

