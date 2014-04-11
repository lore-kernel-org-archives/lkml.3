Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbaDKHcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 03:32:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925AbaDKHb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 03:31:59 -0400
Message-ID: <1397201514.1589.0.camel@linux-fkkt.site>
Subject: Re: [PATCH v7 0/4] Add modules for realtek USB card reader
From: Oliver Neukum <oneukum@suse.de>
To: rogerable@realtek.com
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn
Date: Fri, 11 Apr 2014 09:31:54 +0200
In-Reply-To: <1397199203-2235-1-git-send-email-rogerable@realtek.com>
References: <1397199203-2235-1-git-send-email-rogerable@realtek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-11 at 14:53 +0800, rogerable@realtek.com wrote:
> From: Roger Tseng <rogerable@realtek.com>
> 
> This patchset adds modules to support Realtek USB vendor specific class flash
> card reader: one base module in MFD subsystem and two host modules in both mmc
> and memstick subsystems. The architecture is similar to rtsx_pci.
> 
> This work is done primarily to replace the staging driver: staging/rts5139,
> which doesn't utilize mmc nor memstick subsystems. Once the patchset or its
> revision is applied, we may need Greg's help to remove the staging one.

Looks good to me.

	Regards
		Oliver


