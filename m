Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab3IIPVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:21:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab3IIPVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:21:18 -0400
Date: Mon, 9 Sep 2013 08:24:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, software@gaisler.com
Subject: Re: [PATCH] usb: gadget: Add UDC driver for Aeroflex Gaisler GRUSBDC
Message-ID: <20130909152424.GA26404@kroah.com>
References: <1376316310-27989-1-git-send-email-andreas@gaisler.com>
 <521DBC9E.9080001@gaisler.com>
 <522D5DAB.2060707@gaisler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522D5DAB.2060707@gaisler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 07:33:31AM +0200, Andreas Larsson wrote:
> On 2013-08-28 11:02, Andreas Larsson wrote:
> > On 2013-08-12 16:05, Andreas Larsson wrote:
> >> This adds an UDC driver for GRUSBDC USB Device Controller cores
> >> available in the
> >> GRLIB VHDL IP core library. The driver only supports DMA mode.
> >
> > Any comments? It would be great to get feedback soon in case some things
> > need to be changed for this driver to be accepted. Thanks!
> 
> Anyone?
> 
> Is there anything holding it back from being accepted into mainline?

This is the middle of the merge window, nothing can be accepted at the
moment, please wait until 3.12-rc1 comes out and our trees open up again
to expect a response.

thanks,

greg k-h
