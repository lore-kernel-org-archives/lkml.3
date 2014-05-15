Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaEOTMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:12:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42500 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751191AbaEOTMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:12:19 -0400
Date: Thu, 15 May 2014 15:12:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <joe@perches.com>,
        <auttamchandani@logicube.com>
Subject: Re: [PATCH 2/2 v4] usb: gadget: net2280: Add support for PLX USB338X
In-Reply-To: <20140515160735.GF7360@saruman.home>
Message-ID: <Pine.LNX.4.44L0.1405151511270.887-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Felipe Balbi wrote:

> On Thu, May 15, 2014 at 02:28:46PM +0200, Ricardo Ribalda Delgado wrote:
> > This patch adds support for the PLX USB3380 and USB3382.
> > 
> > This driver is based on the driver from the manufacturer.
> > 
> > Since USB338X is register compatible with NET2280, I thought that it
> > would be better to include this hardware into net2280 driver.
> > 
> > Manufacturer's driver only supported the USB33X, did not follow the
> > Kernel Style and contain some trivial errors. This patch has tried to
> > address this issues.
> > 
> > This patch has only been tested on USB338x hardware, but the merge has
> > been done trying to not affect the behaviour of NET2280.
> > 
> > Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> 
> anybody with net2280, please give me a Tested-by so I'm sure there are
> no regressions caused by this patch. One question though, is it worth to
> use the legacy mode just to get register compatibility ? What are the
> drawbacks of using legacy mode ? Is any feature missing when we use
> legacy mode ?

I tried it out with my net2280 card.  There didn't appear to be any 
problems under light testing.

Tested-by: Alan Stern <stern@rowland.harvard.edu>

