Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935726Ab3DPPfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:35:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42051 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934696Ab3DPPfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:35:15 -0400
Date: Tue, 16 Apr 2013 11:35:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: projekt-wlan@fem.tu-ilmenau.de
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 3735ba8db8e6ea22ad3ff524328926d8d780a884 with
 Freescale P1020
In-Reply-To: <ee76d61e1b4c516ddb933fa533c3443c@fami-braun.de>
Message-ID: <Pine.LNX.4.44L0.1304161134120.1391-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Apr 2013, Michael Braun wrote:

> Hi,
> 
> I'm running OpenWRT Kernel 3.8.3 (which already has 
> f66dea709cd9309b2ee9f715697818001fb518de and 
> 5ed338778f917a035f0f0a52327fc4f72e36f7a1 applied) on a P1020WLAN (QorlQ, 
> PPC) device.
> Before updating the kernel from 3.3.0, USB host support was working 
> fine. Now I get "fsl-ehci: USB PHY clock invalid" messages in dmesg and 
> the lsusb output is empty, so USB host support is not working. When I 
> apply the following patch, USB host support starts working again, so I 
> guess 3735ba8db8e6ea22ad3ff524328926d8d780a884 is the cause.

Why didn't you CC: the author of that commit?  Isn't he the person most 
likely to be able to fix it?

Alan Stern

