Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaIJUfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:35:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaIJUfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:35:47 -0400
Date: Wed, 10 Sep 2014 13:34:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: Paul.Zimmerman@synopsys.com, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] usb: dwc2/gadget: improvements for gadget driver
Message-ID: <20140910203459.GA2350@kroah.com>
References: <1410252297-13738-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410252297-13738-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 10:44:51AM +0200, Robert Baldyga wrote:
> Hi,
> 
> I have splitted my patchset "usb: dwc2/gadget: fix series" into two series.
> This patch series contains improvements for dwc2/gadget driver. It's intended
> for 3.18.
> 
> Andrzej Pietrasiewicz (1):
>   usb: dwc2/gadget: Fix comment text
> 
> Kamil Debski (1):
>   usb: dwc2/gadget: move phy bus legth initialization
> 
> Marek Szyprowski (2):
>   usb: dwc2/gadget: hide some not really needed debug messages
>   usb: dwc2/gadget: ensure that all fifos have correct memory buffers
> 
> Robert Baldyga (2):
>   usb: dwc2/gadget: assign TX FIFO dynamically
>   usb: dwc2/gadget: disable clock when it's not needed
> 
>  drivers/usb/dwc2/core.h   |   3 ++
>  drivers/usb/dwc2/gadget.c | 132 +++++++++++++++++++++++++++++-----------------
>  2 files changed, 86 insertions(+), 49 deletions(-)

As these depend on your previous changes, I'll wait until after those
get merged into Linus's tree before applying them.  Probably sometime
next week.

thanks,

greg k-h
