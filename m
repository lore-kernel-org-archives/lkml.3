Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaK1QJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:09:14 -0500
Received: from netrider.rowland.org ([192.131.102.5]:41851 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751257AbaK1QJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:09:12 -0500
Date: Fri, 28 Nov 2014 11:09:11 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        USB development list <linux-usb@vger.kernel.org>
Subject: Re: [Update][PATCH] USB / PM: Drop CONFIG_PM_RUNTIME from the USB
 core
In-Reply-To: <20267683.eADo9Xo14c@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1411281102170.29147-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2014, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: USB / PM: Drop CONFIG_PM_RUNTIME from the USB core
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so quite a few
> #ifdef blocks depending on CONFIG_PM_RUNTIME may now be changed to
> depend on CONFIG_PM (or even dropped in some cases).
> 
> Replace CONFIG_PM_RUNTIME with CONFIG_PM in the USB core code
> and ABI documentation.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> Added headers and two ABI documentation files, plus one missing instance in
> drivers/usb/core/hcd.c.
> 
> Of course, this depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME
> if PM_SLEEP is selected) which is in linux-next only (via linux-pm) at the
> moment.

There are also one or two places in Documentation/usb that mention 
CONFIG_PM_RUNTIME.

Alan Stern

