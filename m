Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbaDPIJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 04:09:33 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53291 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbaDPIJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 04:09:20 -0400
Date: Wed, 16 Apr 2014 09:09:14 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Roger <rogerable@realtek.com>
Cc: Oliver Neukum <oneukum@suse.de>, Samuel Ortiz <sameo@linux.intel.com>,
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
Message-ID: <20140416080914.GA18122@lee--X1>
References: <1397199203-2235-1-git-send-email-rogerable@realtek.com>
 <1397201514.1589.0.camel@linux-fkkt.site>
 <20140411102846.GB9801@lee--X1>
 <1397212602.4632.2.camel@linux-fkkt.site>
 <534DF6B1.30609@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <534DF6B1.30609@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>>From: Roger Tseng <rogerable@realtek.com>
> >>>>
> >>>>This patchset adds modules to support Realtek USB vendor specific class flash
> >>>>card reader: one base module in MFD subsystem and two host modules in both mmc
> >>>>and memstick subsystems. The architecture is similar to rtsx_pci.
> >>>>
> >>>>This work is done primarily to replace the staging driver: staging/rts5139,
> >>>>which doesn't utilize mmc nor memstick subsystems. Once the patchset or its
> >>>>revision is applied, we may need Greg's help to remove the staging one.
> >>>
> >>>Looks good to me.
> >>
> >>Is that an Ack?
> >Acked-by: Oliver <oneukum@suse.de>
> >
> >	Sorry
> >		Oliver
> >
> Lee,
> 
> Would you apply all of these patches?

In time. I'm still catching up after the merge-window.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
