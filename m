Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaLACzC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 21:55:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaLACzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 21:55:00 -0500
Date: Sun, 30 Nov 2014 18:53:36 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        USB development list <linux-usb@vger.kernel.org>
Subject: Re: [Update 2x][PATCH] USB / PM: Drop CONFIG_PM_RUNTIME from the USB
 core
Message-ID: <20141201025336.GB4331@kroah.com>
References: <Pine.LNX.4.44L0.1411301045010.10461-100000@netrider.rowland.org>
 <22502474.I00WlQ6xeB@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22502474.I00WlQ6xeB@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 02:12:51AM +0100, Rafael J. Wysocki wrote:
> On Sunday, November 30, 2014 10:45:39 AM Alan Stern wrote:
> > On Sat, 29 Nov 2014, Rafael J. Wysocki wrote:
> > 
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> > > selected) PM_RUNTIME is always set if PM is set, so quite a few
> > > #ifdef blocks depending on CONFIG_PM_RUNTIME may now be changed to
> > > depend on CONFIG_PM (or even dropped in some cases).
> > > 
> > > Replace CONFIG_PM_RUNTIME with CONFIG_PM in the USB core code
> > > and documentation.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > ---
> > > 
> > > Added the Documentation/usb/power-management.txt changes.
> > > 
> > > Of course, this depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME
> > > if PM_SLEEP is selected) which is in linux-next only (via linux-pm) at the
> > > moment.
> > 
> > Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 
> Thanks!
> 
> Greg, would there be any problems if I took this into the linux-pm tree?

No problems at all:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
