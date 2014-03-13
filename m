Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbaCMWqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 18:46:48 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36622 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbaCMWqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:46:47 -0400
Date: Thu, 13 Mar 2014 22:46:42 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 3/8] mfd: lpc_ich: Remove lpc_ich_cfg struct use
Message-ID: <20140313224642.GE28504@lee--X1>
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
 <1394487298-14459-3-git-send-email-ptyser@xes-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394487298-14459-3-git-send-email-ptyser@xes-inc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Future chipsets will use different register layouts that don't map
> cleanly to the lpc_ich_cfg fields.  Remove the lpc_ich_cfg struct and
> add explicit fields to the higher level lpc_ich_priv structure.
> 
> This change should have no functional impact.
> 
> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> Tested-by: Rajat Jain <rajatjain@juniper.net>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: James Ralston <james.d.ralston@intel.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/lpc_ich.c |   63 +++++++++++++++++++++++++------------------------
>  1 files changed, 32 insertions(+), 31 deletions(-)

Applied with Guenter's Reviewed-by.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
