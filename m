Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab3CDP0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 10:26:43 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44937 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757041Ab3CDP0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 10:26:41 -0500
Date: Mon, 4 Mar 2013 10:26:40 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Hannes Reinecke <hare@suse.de>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Oliver Neukum <oneukum@suse.de>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Frederik Himpe <fhimpe@vub.ac.be>, David Haerdeman <david@hardeman.nu>
Subject: Re: [PATCH][v2] xhci: correctly enable interrupts
In-Reply-To: <1362385324-15228-1-git-send-email-hare@suse.de>
Message-ID: <Pine.LNX.4.44L0.1303041025470.1750-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Mar 2013, Hannes Reinecke wrote:

> xhci has its own interrupt enabling routine, which will try to
> use MSI-X/MSI if present. So the usb core shouldn't try to enable
> legacy interrupts; on some machines the xhci legacy IRQ setting
> is invalid.

This version of the patch is much better than the first one, IMO.  
Thank you.

Alan Stern

