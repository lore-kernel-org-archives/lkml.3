Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669Ab3JOUN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:13:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58677 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759341Ab3JOUN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:13:27 -0400
Date: Tue, 15 Oct 2013 16:13:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
cc: gregkh@linuxfoundation.org, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <patches@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] USB: OHCI: Only use ohci_driver_overrides if they are
 defined
In-Reply-To: <20131015170902.GB20219@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.44L0.1310151612190.1377-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013, Charles Keepax wrote:

> Apologies looks like I was on an earlier RC there and the users
> that did this have been removed. I assume this patch can be
> ignored sorry for the noise.

Actually it's the other way around.  The change you submitted has 
already been merged:

https://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git/commit/drivers/usb/host/ohci-hcd.c?h=usb-next&id=c80ad6d1cd6c6662d0cff752d94a1a9fde6de4ac

Alan Stern

