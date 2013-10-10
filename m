Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab3JJKwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:52:44 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:37197 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3JJKwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:52:42 -0400
Date: Thu, 10 Oct 2013 03:52:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        platform-driver-x86@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH v2 09/10] intel_mid: Moved board related code to a new
 file
Message-ID: <20131010105235.GA25140@roeck-us.net>
References: <1381384807-14146-1-git-send-email-david.a.cohen@linux.intel.com>
 <1381384807-14146-10-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381384807-14146-10-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 11:00:06PM -0700, David Cohen wrote:
> From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> 
> +# I2C Devices
> +obj-$(subst m,y,$(CONFIG_SENSORS_EMC1403)) += platform_emc1403.o
> +obj-$(subst m,y,$(CONFIG_SENSORS_LIS3LV02D)) += platform_lis331.o

I am a bit confused by the platform data for the above i2c devices.
The driver for EMC1403 does supports neither interrupts nor platform data.
The driver for LIS3LV02D supports both, but the platform data does not
seem to match what is provided here. Am I missing something ?

> +obj-$(subst m,y,$(CONFIG_GPIO_PCA953X)) += platform_max7315.o
> +obj-$(subst m,y,$(CONFIG_SENSORS_MPU3050)) += platform_mpu3050.o

Do you possibly mean CONFIG_INPUT_MPU3050 ?

Guenter
