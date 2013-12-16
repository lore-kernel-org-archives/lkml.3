Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab3LPWie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 17:38:34 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:60440 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751019Ab3LPWid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 17:38:33 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 64.17.244.34
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1800br9SXVO+lds2hZ7A3Ic
Date: Mon, 16 Dec 2013 14:38:27 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, linux-kernel@vger.kernel.org,
        marek.belisko@gmail.com, linux@arm.linux.org.uk,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        hns@goldelico.com
Subject: Re: [PATCH v3 0/2] usb: fix controller-PHY binding for OMAP3 platform
Message-ID: <20131216223826.GG26293@atomide.com>
References: <1387209225-11520-1-git-send-email-kishon@ti.com>
 <20131216212918.GH12896@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216212918.GH12896@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [131216 13:31]:
> Hi,
> 
> On Mon, Dec 16, 2013 at 09:23:43PM +0530, Kishon Vijay Abraham I wrote:
> > After the platform devices are created using PLATFORM_DEVID_AUTO, the
> > device names given in usb_bind_phy (in board file) does not match with
> > the actual device name causing the USB PHY library not to return the
> > PHY reference when the MUSB controller request for the PHY in the non-dt boot
> > case.
> > So removed creating platform devices using PLATFORM_DEVID_AUTO in omap2430.c.
> > 
> > Did enumeration testing in omap3 beagle.
> > 
> > Changes from v2:
> > * Fixed the commit log
> > 
> > Changes from v1:
> > * refreshed to the latested mainline kernel
> > * added musb_put_id from omap2430 remove.
> 
> Tony, how do you want to handle this ? You want me to provide you a
> branch which we both merge ?

Yes that would be great thanks. For the mach-omap2 touching parts:

Acked-by: Tony Lindgren <tony@atomide.com>
