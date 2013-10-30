Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3J3RgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:36:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3J3RgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:36:16 -0400
Date: Wed, 30 Oct 2013 10:36:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        Frank Haverkamp <haver@vnet.ibm.com>
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
Message-ID: <20131030173615.GC20147@kroah.com>
References: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
 <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 10:32:58AM +0100, Frank Haverkamp wrote:
> +/*
> + * Module initialization and PCIe setup. Card health monitoring and
> + * recovery functionality. Character device creation and deletion are
> + * controlled from here.
> + *
> + * Please use the new sysfs interfaces to enable the VFs after PF
> + * driver loading.
> + *
> + * Enable VFs:
> + *   sudo sh -c 'echo 15 > /sys/bus/pci/devices/0000\:1b\:00.0/sriov_numvfs'
> + * or
> + *   sudo sh -c 'echo 15 > /sys/class/genwqe/genwqe0_card/device/sriov_numvfs'
> + * Disable VFs:
> + *   Write a 0 into the same sysfs entries.
> + */

Put this documentation somewhere a user has a _chance_ of reading it.
Digging it out of code comments is not ok.  Why isn't this in the ABI
file for the sysfs files?

thanks,

greg k-h
