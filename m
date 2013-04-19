Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030850Ab3DSPn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 11:43:29 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:50518 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030656Ab3DSPn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 11:43:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/8KDyv0Wvsr6HkZroTuChT
Date: Fri, 19 Apr 2013 08:43:22 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: b-cousson@ti.com, nm@ti.com, paul@pwsan.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v3 0/4] ARM: dts: Add USB host support for Panda and
 Beagle-xm
Message-ID: <20130419154321.GG10155@atomide.com>
References: <1366365457-28972-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366365457-28972-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [130419 03:02]:
> Hi Benoit/Tony
> 
> I've consolidated all the USB host device tree patches for Panda and Beagles
> to one place and addressed Tony's comments.
> 
> NOTE: patch 1 depends on OMAP clock binding introduced in
> https://lkml.org/lkml/2013/4/12/407
> 
> v3:
> - updated mux mode to use pulldowns on panda as non-DT boot uses pulldowns.
> - fixed usb pin naming for panda, beagle and beagle-xm

Cool. Sounds like we should be able to make omap4 DT only for v3.11
then. For that we also need USB on 4430-sdp working, but it now
does:

ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-omap 4a064c00.ehci: failed to get phys phandle in /ocp/usbhshost@4a064000/ehci@4a064c00 node
ehci-omap 4a064c00.ehci: failed to get phys phandle in /ocp/usbhshost@4a064000/ehci@4a064c00 node
...

As I have mine in a rack I don't have anything plugged into the
USB port there though, but sounds like the phy is not initialized?

Regards,

Tony
