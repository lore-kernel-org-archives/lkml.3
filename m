Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3HAHaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:30:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3HAHat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:30:49 -0400
Date: Wed, 31 Jul 2013 18:45:12 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
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
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH 1/5] Intel MIC Host Driver for X100 family.
Message-ID: <20130801014512.GC6941@kroah.com>
References: <cover.1374717252.git.sudeep.dutt@intel.com>
 <be8c714ed743143c427058fc0b75722f2eeeee1c.1374717252.git.sudeep.dutt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be8c714ed743143c427058fc0b75722f2eeeee1c.1374717252.git.sudeep.dutt@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 08:31:32PM -0700, Sudeep Dutt wrote:
> This patch enables the following:
> a) Initializes the Intel MIC X100 PCIe devices.
> b) Boots and shuts down the card via sysfs entries.
> c) Allocates and maps a device page for communication with the
> card driver and updates the device page address via scratchpad
> registers.
> d) Provides sysfs entries for family, stepping, state, shutdown
> status, kernel command line, IP address, ramdisk and log buffer
> information.

That's a lot to do in one patch, almost 4 thousand lines.  Can't you
break this up into some more smaller, logical, and reviewable, pieces?

For example, I have no idea what b) is, and how to separate it from the
things you do for a) and c).

thanks,

greg k-h
