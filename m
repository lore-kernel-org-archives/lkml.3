Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaHUSpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 14:45:08 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50885 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbaHUSpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 14:45:05 -0400
Date: Thu, 21 Aug 2014 11:45:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Andreas Werner <andreas.werner@men.de>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lee.jones@linaro.org,
        wim@iguana.be, linux-watchdog@vger.kernel.org, cooloney@gmail.com,
        rpurdie@rpsys.net, linux-leds@vger.kernel.org, jdelvare@suse.de,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH v4 4/4] drivers/hwmon/menf21bmc_hwmon: introduce
 MEN14F021P00 BMC HWMON driver
Message-ID: <20140821184501.GC16045@roeck-us.net>
References: <cover.1407918792.git.andreas.werner@men.de>
 <cf0593273cbadcb16b094b7bc3bd9d3b5a93f7ed.1407918792.git.andreas.werner@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf0593273cbadcb16b094b7bc3bd9d3b5a93f7ed.1407918792.git.andreas.werner@men.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 10:40:37AM +0200, Andreas Werner wrote:
> Added driver to support the 14F021P00 BMC Hardware Monitoring.
> The BMC is a Board Management Controller including monitoring of the
> board voltages.
> 
> Signed-off-by: Andreas Werner <andreas.werner@men.de>
> ---
>  drivers/hwmon/Kconfig           |   7 ++
>  drivers/hwmon/Makefile          |   1 +
>  drivers/hwmon/menf21bmc_hwmon.c | 238 ++++++++++++++++++++++++++++++++++++++++

Forgot: Please also provide Documentation/hwmon/menf21bmc.

Thanks,
Guenter
