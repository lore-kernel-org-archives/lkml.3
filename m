Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693Ab3D3T6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 15:58:05 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51472 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932735Ab3D3T57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 15:57:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Subject: Re: [PATCH 2/3 RFC] Driver core: Use generic offline/online for CPU offline/online
Date: Tue, 30 Apr 2013 22:06:14 +0200
Message-ID: <4838852.rhr5DNSfPE@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130430152753.GC8204@kroah.com>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan> <18234756.omYDfXWPpx@vostro.rjw.lan> <20130430152753.GC8204@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 30, 2013 08:27:53 AM Greg Kroah-Hartman wrote:
> On Tue, Apr 30, 2013 at 02:01:10PM +0200, Rafael J. Wysocki wrote:
> > On Monday, April 29, 2013 04:11:06 PM Greg Kroah-Hartman wrote:
> > > On Mon, Apr 29, 2013 at 02:28:02PM +0200, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > 
> > > > Rework the CPU hotplug code in drivers/base/cpu.c to use the
> > > > generic offline/online support introduced previously instead of
> > > > its own CPU-specific code.
> > > > 
> > > > For this purpose, modify cpu_subsys to provide offline and online
> > > > callbacks for CONFIG_HOTPLUG_CPU set and remove the code handling
> > > > the CPU-specific 'online' sysfs attribute.
> > > > 
> > > > This modification is not supposed to change the user-observable
> > > > behavior of the kernel (i.e. the 'online' attribute will be present
> > > > in exactly the same place in sysfs and should trigger exactly the
> > > > same actions as before).
> > > > 
> > > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > ---
> > > >  drivers/base/cpu.c |   62 ++++++++++++-----------------------------------------
> > > >  1 file changed, 15 insertions(+), 47 deletions(-)
> > > 
> > > Very nice, I like reductions like this :)
> > 
> > Thanks!
> > 
> > So I guess the patches make sense to you overall?
> 
> Overall, yes, I like them a lot.

Cool, thanks! :-)

Rafael

