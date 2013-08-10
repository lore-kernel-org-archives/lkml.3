Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab3HJME6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 08:04:58 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45320 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758248Ab3HJME5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 08:04:57 -0400
Date: Sat, 10 Aug 2013 08:04:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Thomas Richter <richter@rus.uni-stuttgart.de>
cc: linux@brodo.de, <linux-kernel@vger.kernel.org>
Subject: Re: [HANG] Trouble with NEC-based USB adapter in PCMCIA slot on
 E7110
In-Reply-To: <52062353.9030800@rus.uni-stuttgart.de>
Message-ID: <Pine.LNX.4.44L0.1308100801470.31571-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Aug 2013, Thomas Richter wrote:

> Which modules are relevant for handling the communication with the 
> device, and where would you suggest to start looking? I assume 
> yenta_socket is one thing for the cartbus adapter, then we have ehci_hcd 
> and ehci_pci. Do I assume correctly that we can rule out the ohci_hcd 
> module since that is not involved?

That's right.

>  What about other usb modules? I would 
> probably need a short recap on through which modules the user data flows 
> before the write is triggered, and which modules are involved in the 
> configuration of the NEC ehci host adapter.

Start with just the ones you have identified.  If that doesn't fix the 
problem then we can look further.

Alan Stern

