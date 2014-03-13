Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaCMWqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 18:46:15 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:64694 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaCMWqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:46:14 -0400
Date: Thu, 13 Mar 2014 22:46:08 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/8] mfd: lpc_ich: Only configure watchdog or GPIO when
 present
Message-ID: <20140313224608.GD28504@lee--X1>
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
 <1394487298-14459-2-git-send-email-ptyser@xes-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394487298-14459-2-git-send-email-ptyser@xes-inc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Some chipsets don't currently have GPIO support enabled.  For these
> chipsets don't go through the process of initializing the GPIO region.
> 
> Make the same change for the watchdog initialization for chipsets which
> may not enable the WDT in the future.
> 
> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> Tested-by: Rajat Jain <rajatjain@juniper.net>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: James Ralston <james.d.ralston@intel.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/lpc_ich.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)

Applied with Guenter's Reviewed-by.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
