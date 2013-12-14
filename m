Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab3LNSqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 13:46:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62035 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab3LNSqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 13:46:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 00/12] i8k patch series
Date: Sat, 14 Dec 2013 19:45:19 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
References: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201312141945.20348.arnd@arndb.de>
X-Provags-ID: V02:K0:Pb3eaBGZdfYtriPt+lDUZcjjBFv9QfLu2XBSo6+79HX
 Rg7KmRifBfnm1c6Mi62CtqMxCnh1XgGeSYfeLT/yP0uE3S4CWc
 cC2VlTwNUBbmODqteDOJp3jBa2rEcf+jIAVJyYHiG3D0sqRPwX
 eXt3BUX0IS+Z5MO8nSp6BaN1usAQuxPb19dTbQnZkS3U/2GtIW
 cA+oO9xD8mow15DdUa7u+coP5Qs7G1Zx+/7msEOHW9eirTbPSN
 OdFeblvUp8w52FZC1BT1IimdcLt5K0W3jxbWirklrs2ssEHQMc
 KswSRMaFfr5Q3vlhth2U9QfXTAab97G2ofmhuQJmAUr9A+h90a
 rxpTw1pO3h2yh1c49kyE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 December 2013, Guenter Roeck wrote:
> Clean up and simplify the driver, add support for additional temperature
> sensors, fix a problem seen with multi-core CPU, and add support
> for additional systems.
> 
> ----------------------------------------------------------------
> Guenter Roeck (14):
>       i8k: Convert to use pr_ functions instead of printk
>       i8k: Fix various checkpatch warnings and errors
>       i8k: Convert to use to hwmon_device_register_with_groups hwmon API
>       i8k: Support additional temperature sensors
>       MAINTAINERS: Add myself as i8k maintainer
>       i8k: Remove obsolete link to out-of-tree driver
>       i8k: Drop driver version number and info message at startup
>       i8k: Force SMM to run on CPU 0
>       i8k: Add copyright
>       i8k: Add support for Dell Studio laptops
>       i8k: Add support for Dell XPS M140
>       i8k: Use driver_data field of dmi_system_id to override fan multiplier
>       i8k: Stop reading SMM BIOS version during driver probe
>       i8k: Implement hwmon based fan speed control
> 
>  MAINTAINERS        |    2 +-
>  drivers/char/i8k.c |  358 +++++++++++++++++++++++++++++-----------------------
>  2 files changed, 201 insertions(+), 159 deletions(-)
> 

All changes in this patch set look good to me.

Acked-by: Arnd Bergmann <arnd@arndb.de>

I wonder if it makes sense to move the driver to drivers/platform/x86/, which
has a bunch of similar ones already.

	Arnd
