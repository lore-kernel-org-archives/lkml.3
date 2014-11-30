Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaK3Ppn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 10:45:43 -0500
Received: from netrider.rowland.org ([192.131.102.5]:38942 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752127AbaK3Ppl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 10:45:41 -0500
Date: Sun, 30 Nov 2014 10:45:39 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        USB development list <linux-usb@vger.kernel.org>
Subject: Re: [Update 2x][PATCH] USB / PM: Drop CONFIG_PM_RUNTIME from the
 USB core
In-Reply-To: <4725195.YHuDH3PCnx@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1411301045010.10461-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2014, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so quite a few
> #ifdef blocks depending on CONFIG_PM_RUNTIME may now be changed to
> depend on CONFIG_PM (or even dropped in some cases).
> 
> Replace CONFIG_PM_RUNTIME with CONFIG_PM in the USB core code
> and documentation.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> Added the Documentation/usb/power-management.txt changes.
> 
> Of course, this depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME
> if PM_SLEEP is selected) which is in linux-next only (via linux-pm) at the
> moment.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

