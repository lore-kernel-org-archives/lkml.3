Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaETOwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:52:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42535 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751092AbaETOwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:52:44 -0400
Date: Tue, 20 May 2014 10:52:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
cc: "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        Amit Uttamchandani <auttamchandani@logicube.com>
Subject: Re: [PATCH 2/9] usb: gadget: net2280: Dont use magic numbers
In-Reply-To: <CAPybu_2KztdWmExKXO8uEebpQPouN7wqQww5ZzknmC5-hXvDJA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1405201052080.1176-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014, Ricardo Ribalda Delgado wrote:

> Hello Alan
> 
> In this case, there are only two family of devices supported by the
> driver. Maybe quirks are too much.
> 
> At the end:
> 
> ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY
> 
> is not much bigger than
> 
> ep->dev->quirk_flag & PLX_NET2280_QUIRK
> 
> But if you prefer the quirk I dont mind implementing it, but please as
> a follow-up patch, since there are 8 patches depending on this :)

It's not a big deal.  Up to you.

Alan Stern

