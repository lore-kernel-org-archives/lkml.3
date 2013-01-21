Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab3AUWgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:36:09 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48551 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab3AUWgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:36:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC][Update 2][PATCH 4/4] ACPI / PM: Expose lists of device power resources to user space
Date: Mon, 21 Jan 2013 23:42:06 +0100
Message-ID: <1897042.j2EJ9nIq6C@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130121205846.GD17006@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <75501802.qSzsX3NXGt@vostro.rjw.lan> <20130121205846.GD17006@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 21, 2013 12:58:46 PM Greg Kroah-Hartman wrote:
> On Mon, Jan 21, 2013 at 02:08:16PM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Since ACPI power resources are going to be used more extensively on
> > new hardware platforms, it is necessary to allow user space (powertop
> > in particular) to look at the lists of power resources corresponding
> > to different power states of devices for diagnostics and control
> > purposes.
> > 
> > For this reason, for each power state of an ACPI device node using
> > power resources create a special attribute group under the device
> > node's directory in sysfs containing links to sysfs directories
> > representing the power resources in that list.  The names of the
> > new attribute groups are "power_resources_<state>", where <state>
> > is the state name i.e. "D0", "D1", "D2", or "D3hot".
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> You aren't calling sysfs_add_link() here, so why did you export it in
> the previous patch?

Well, unnecessarily.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
