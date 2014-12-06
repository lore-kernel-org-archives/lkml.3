Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaLFE23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 23:28:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaLFE22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 23:28:28 -0500
Date: Fri, 5 Dec 2014 20:28:26 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Tejun Heo <tj@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Felipe Balbi <balbi@ti.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lu@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] PM / Kconfig: Replace PM_RUNTIME with PM in dependencies
Message-ID: <20141206042826.GA3398@kroah.com>
References: <1710744.OD8H2BOPgr@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1710744.OD8H2BOPgr@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2014 at 03:54:35AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so Kconfig options
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
> 
> Replace PM_RUNTIME with PM in Kconfig dependencies throughout the
> tree.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
