Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3LNRiX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 12:38:23 -0500
Received: from mail.active-venture.com ([67.228.131.205]:57822 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab3LNRiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 12:38:22 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sat, 14 Dec 2013 11:38:22 -0600
X-Originating-IP: 108.223.40.66
Message-ID: <52AC978D.6020602@roeck-us.net>
Date: Sat, 14 Dec 2013 09:38:21 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 00/12] i8k patch series
References: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2013 09:30 AM, Guenter Roeck wrote:
> Clean up and simplify the driver, add support for additional temperature
> sensors, fix a problem seen with multi-core CPU, and add support
> for additional systems.
>
Sigh. Headline should have read 00/14, obviously.

Guenter

> ----------------------------------------------------------------
> Guenter Roeck (14):
>        i8k: Convert to use pr_ functions instead of printk
>        i8k: Fix various checkpatch warnings and errors
>        i8k: Convert to use to hwmon_device_register_with_groups hwmon API
>        i8k: Support additional temperature sensors
>        MAINTAINERS: Add myself as i8k maintainer
>        i8k: Remove obsolete link to out-of-tree driver
>        i8k: Drop driver version number and info message at startup
>        i8k: Force SMM to run on CPU 0
>        i8k: Add copyright
>        i8k: Add support for Dell Studio laptops
>        i8k: Add support for Dell XPS M140
>        i8k: Use driver_data field of dmi_system_id to override fan multiplier
>        i8k: Stop reading SMM BIOS version during driver probe
>        i8k: Implement hwmon based fan speed control
>
>   MAINTAINERS        |    2 +-
>   drivers/char/i8k.c |  358 +++++++++++++++++++++++++++++-----------------------
>   2 files changed, 201 insertions(+), 159 deletions(-)
>
>

