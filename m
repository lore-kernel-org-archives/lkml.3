Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab3KDQUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:20:46 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:47784 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3KDQUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:20:45 -0500
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        Frank Haverkamp <haver@vnet.ibm.com>
In-Reply-To: <20131030173615.GC20147@kroah.com>
References: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
	 <20131030173615.GC20147@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Mon, 04 Nov 2013 17:20:34 +0100
Message-ID: <1383582034.15642.8.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110416-0542-0000-0000-000006F30B9C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Mittwoch, den 30.10.2013, 10:36 -0700 schrieb Greg KH:
> On Wed, Oct 30, 2013 at 10:32:58AM +0100, Frank Haverkamp wrote:
> > +/*
> > + * Module initialization and PCIe setup. Card health monitoring and
> > + * recovery functionality. Character device creation and deletion are
> > + * controlled from here.
> > + *
> > + * Please use the new sysfs interfaces to enable the VFs after PF
> > + * driver loading.
> > + *
> > + * Enable VFs:
> > + *   sudo sh -c 'echo 15 > /sys/bus/pci/devices/0000\:1b\:00.0/sriov_numvfs'
> > + * or
> > + *   sudo sh -c 'echo 15 > /sys/class/genwqe/genwqe0_card/device/sriov_numvfs'
> > + * Disable VFs:
> > + *   Write a 0 into the same sysfs entries.
> > + */
> 
> Put this documentation somewhere a user has a _chance_ of reading it.
> Digging it out of code comments is not ok.  Why isn't this in the ABI
> file for the sysfs files?
> 
> thanks,
> 
> greg k-h
> 

True. There was other stuff I moved/deleted now too.

Regards

Frank



