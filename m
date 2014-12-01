Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725AbaLAWJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:09:29 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60836 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932540AbaLAWJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:09:25 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        USB development list <linux-usb@vger.kernel.org>
Subject: Re: [Update 2x][PATCH] USB / PM: Drop CONFIG_PM_RUNTIME from the USB core
Date: Mon, 01 Dec 2014 23:30:48 +0100
Message-ID: <3257245.qgDrRr7FeH@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141201025336.GB4331@kroah.com>
References: <Pine.LNX.4.44L0.1411301045010.10461-100000@netrider.rowland.org> <22502474.I00WlQ6xeB@vostro.rjw.lan> <20141201025336.GB4331@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 30, 2014 06:53:36 PM Greg Kroah-Hartman wrote:
> On Mon, Dec 01, 2014 at 02:12:51AM +0100, Rafael J. Wysocki wrote:
> > On Sunday, November 30, 2014 10:45:39 AM Alan Stern wrote:
> > > On Sat, 29 Nov 2014, Rafael J. Wysocki wrote:
> > > 
> > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > 
> > > > After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> > > > selected) PM_RUNTIME is always set if PM is set, so quite a few
> > > > #ifdef blocks depending on CONFIG_PM_RUNTIME may now be changed to
> > > > depend on CONFIG_PM (or even dropped in some cases).
> > > > 
> > > > Replace CONFIG_PM_RUNTIME with CONFIG_PM in the USB core code
> > > > and documentation.
> > > > 
> > > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > ---
> > > > 
> > > > Added the Documentation/usb/power-management.txt changes.
> > > > 
> > > > Of course, this depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME
> > > > if PM_SLEEP is selected) which is in linux-next only (via linux-pm) at the
> > > > moment.
> > > 
> > > Acked-by: Alan Stern <stern@rowland.harvard.edu>
> > 
> > Thanks!
> > 
> > Greg, would there be any problems if I took this into the linux-pm tree?
> 
> No problems at all:
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks!

