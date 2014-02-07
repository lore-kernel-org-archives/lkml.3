Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaBGWc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 17:32:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaBGWc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 17:32:27 -0500
Date: Fri, 7 Feb 2014 14:33:37 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: rogerable@realtek.com
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <cjb@laptop.org>, Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        driverdev-devel@linuxdriverproject.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei_wang@realsil.com.cn
Subject: Re: [PATCH v3 0/3] Add modules for realtek USB card reader
Message-ID: <20140207223337.GA21142@kroah.com>
References: <1391697307-23457-1-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391697307-23457-1-git-send-email-rogerable@realtek.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 10:35:04PM +0800, rogerable@realtek.com wrote:
> From: Roger Tseng <rogerable@realtek.com>
> 
> This patchset adds modules to support Realtek USB vendor specific class flash
> card reader: one base module in MFD subsystem and two host modules in both mmc
> and memstick subsystems. The architecture is similar to rtsx_pci.
> 
> This work is done primarily to replace the staging driver: staging/rts5139,
> which doesn't utilize mmc nor memstick subsystems. Once the patchset or its
> revision is applied, we may need Greg's help to remove the staging one.
> 
> v2:
> 1. Fix potential buffer overflow in rtsx_usb_seq_write_register()
> 2. Remove unnecessary casting and messages
> 3. Revise coding style and white spaces
> 
> v3:
> 1. Fix MMC detection fail when under xhci
> 2. Minor change of pm_runtime behavior in rtsx_usb_ms to prevent some rare
>    freeze due to erroneous Memstick card(not MS-Pro)
> 3. Further revise coding style as suggested in the thread of v2
> 4. Using managed resources: devm_*
> 5. Change license from "GPL v2 and later" to "GPL v2"
> 
> Roger Tseng (3):
>   mfd: Add realtek USB card reader driver
>   mmc: Add realtek USB sdmmc host driver
>   memstick: Add realtek USB memstick host driver

Looks good to me, thanks for doing this work:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
