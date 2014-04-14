Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaDNCOy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 22:14:54 -0400
Received: from netrider.rowland.org ([192.131.102.5]:39990 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750826AbaDNCOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 22:14:52 -0400
Date: Sun, 13 Apr 2014 22:14:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Stefani Seibold <stefani@seibold.net>
cc: linux-usb <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, <sarah.a.sharp@linux.intel.com>
Subject: Re: Missing USB XHCI and EHCI reset for kexec
In-Reply-To: <1397416959.1555.30.camel@vger.seibold.net>
Message-ID: <Pine.LNX.4.44L0.1404132213290.24243-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2014, Stefani Seibold wrote:

> When executing a kexec kernel on a PowerPC board the new started kernel
> will not find already enumerated USB devices due a missing reset on the
> USB bus.

How do you know the problem is caused by a missing reset?

Can you post the dmesg log from the kexec-ed kernel, with 
CONFIG_USB_DEBUG enabled?

Alan Stern

