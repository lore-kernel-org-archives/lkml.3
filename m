Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3HBAmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 20:42:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:53702 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab3HBAmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 20:42:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,797,1367996400"; 
   d="scan'208";a="340417803"
Subject: Re: [PATCH 1/5] Intel MIC Host Driver for X100 family.
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
In-Reply-To: <20130801014512.GC6941@kroah.com>
References: <cover.1374717252.git.sudeep.dutt@intel.com>
	 <be8c714ed743143c427058fc0b75722f2eeeee1c.1374717252.git.sudeep.dutt@intel.com>
	 <20130801014512.GC6941@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Aug 2013 17:38:42 -0700
Message-ID: <1375403922.61060.73.camel@blbiskey-desk1.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-31 at 18:45 -0700, Greg Kroah-Hartman wrote: 
> On Wed, Jul 24, 2013 at 08:31:32PM -0700, Sudeep Dutt wrote:
> > This patch enables the following:
> > a) Initializes the Intel MIC X100 PCIe devices.
> > b) Boots and shuts down the card via sysfs entries.
> > c) Allocates and maps a device page for communication with the
> > card driver and updates the device page address via scratchpad
> > registers.
> > d) Provides sysfs entries for family, stepping, state, shutdown
> > status, kernel command line, IP address, ramdisk and log buffer
> > information.
> 
> That's a lot to do in one patch, almost 4 thousand lines.  Can't you
> break this up into some more smaller, logical, and reviewable, pieces?
> 

Sure, we have started working on breaking up patch1 into smaller pieces.
The next revision will have these changes.
Thanks,
Sudeep Dutt

> For example, I have no idea what b) is, and how to separate it from the
> things you do for a) and c).
> 
> thanks,
> 
> greg k-h



