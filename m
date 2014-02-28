Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaB1W4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:56:43 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54415 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaB1W4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:56:41 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX196JT94lC0klKmkA7eAzMb/
Date: Fri, 28 Feb 2014 14:56:28 -0800
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: lee.jones@linaro.org, bcousson@baylibre.com, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v9 0/9] USB Host support for OMAP5 uEVM
Message-ID: <20140228225627.GU13624@atomide.com>
References: <1393510711-4697-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393510711-4697-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140227 06:21]:
> Hi,
> 
> This patchset brings up USB Host ports and Ethernet port on
> the OMAP5 uEVM board.
> 
> It also does some cleanup with respect to DT clock binding
> for the mfd/omap-usb-host driver.
> 
> Please queue these for -next.
> 
> Lee,
> 
> I've folded some platform data dependent patches with mfd patches
> so that they don't break functionality when applied individually.
> You can safely pull in all MFD patches (1 to 6).
> 
> Tony & Benoit,
> 
> Can you please accept patches 7, 8 and 9?

Are 7, 8 and 9 safe to queue separately from the MFD changes
or do they need to wait for the MFD changes to get merged
first?

Regards,

Tony
