Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaIXMBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:01:06 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:49666 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaIXMBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:01:03 -0400
Date: Wed, 24 Sep 2014 13:00:56 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Grant Likely <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [RFC PATCH v2 05/16] mfd: Add ACPI support
Message-ID: <20140924120056.GB32069@lee--X1>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <1410868367-11056-6-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410868367-11056-6-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014, Mika Westerberg wrote:
> If an MFD device is backed by ACPI namespace, we should allow subdevice
> drivers to access their corresponding ACPI companion devices through normal
> means (e.g using ACPI_COMPANION()).
> 
> This patch adds such support to the MFD core. If the MFD parent device
> does not specify any ACPI _HID/_CID for the child device, the child
> device will share the parent ACPI companion device. Otherwise the child
> device will be assigned with the corresponding ACPI companion, if found
> in the namespace below the parent.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Reviewed-by: Darren Hart <dvhart@linux.intel.com>
> ---
> Lee, I tried to get rid of #ifdefs in the below patch but it wasn't
> possible because we are using functions that are not available when
> !CONFIG_ACPI.
> 
>  Documentation/acpi/enumeration.txt | 27 +++++++++++++++++++++++++
>  drivers/mfd/mfd-core.c             | 40 ++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/core.h           |  3 +++
>  3 files changed, 70 insertions(+)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
