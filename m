Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbaCMWtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 18:49:11 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35306 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbaCMWtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:49:08 -0400
Date: Thu, 13 Mar 2014 22:49:04 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 8/8] mfd: lpc_ich: Add support for Intel Bay Trail SoC
Message-ID: <20140313224904.GJ28504@lee--X1>
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
 <1394487298-14459-8-git-send-email-ptyser@xes-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394487298-14459-8-git-send-email-ptyser@xes-inc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds the LPC Controller Device IDs for Watchdog and GPIO for
> the Intel Bay Trail Atom SoC.
> 
> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: James Ralston <james.d.ralston@intel.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/lpc_ich.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)

Applied with Guenter's Reviewed-by.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
