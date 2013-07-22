Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab3GVP1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:27:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36756 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756484Ab3GVP1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:27:45 -0400
Date: Mon, 22 Jul 2013 11:27:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Hurley <peter@hurleysoftware.com>
cc: Jiri Kosina <jkosina@suse.cz>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        <benjamin.tissoires@gmail.com>, <adlr@chromium.org>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] Revert "Revert "HID: Fix logitech-dj: missing Unifying
 device issue""
In-Reply-To: <51ED3BC3.40300@hurleysoftware.com>
Message-ID: <Pine.LNX.4.44L0.1307221126190.1495-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jul 2013, Peter Hurley wrote:

> On 07/22/2013 07:44 AM, Jiri Kosina wrote:
...
> > Seems like this might be a part of the picture, but not a complete one.
> > Linus claims to have similar problem, but his receiver is not connected
> > through xHCI (I got this as an off-list report, so can't really provide a
> > pointer to ML archives).
> 
> Ah, ok. I wasn't aware of that. I'll assume then that the necessary
> people have the complete picture.

It might help to get a usbmon trace and dmesg log from Linus, if he
still has this problem.

Alan Stern

