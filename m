Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030392AbaDKK26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:28:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56581 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965462AbaDKK2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:28:52 -0400
Date: Fri, 11 Apr 2014 11:28:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Oliver Neukum <oneukum@suse.de>
Cc: rogerable@realtek.com, Samuel Ortiz <sameo@linux.intel.com>,
        Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn
Subject: Re: [PATCH v7 0/4] Add modules for realtek USB card reader
Message-ID: <20140411102846.GB9801@lee--X1>
References: <1397199203-2235-1-git-send-email-rogerable@realtek.com>
 <1397201514.1589.0.camel@linux-fkkt.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397201514.1589.0.camel@linux-fkkt.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Roger Tseng <rogerable@realtek.com>
> > 
> > This patchset adds modules to support Realtek USB vendor specific class flash
> > card reader: one base module in MFD subsystem and two host modules in both mmc
> > and memstick subsystems. The architecture is similar to rtsx_pci.
> > 
> > This work is done primarily to replace the staging driver: staging/rts5139,
> > which doesn't utilize mmc nor memstick subsystems. Once the patchset or its
> > revision is applied, we may need Greg's help to remove the staging one.
> 
> Looks good to me.

Is that an Ack?

> 	Regards
> 		Oliver
> 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
