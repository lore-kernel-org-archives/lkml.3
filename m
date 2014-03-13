Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaCMIDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:03:32 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:44850 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaCMID3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:03:29 -0400
Date: Thu, 13 Mar 2014 08:03:24 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, sbkim73@samsung.com
Subject: Re: [PATCH v3] drivers: mfd: silence compiler warning in sec-core.c
Message-ID: <20140313080324.GB8740@lee--X1>
References: <1394017159-4851-1-git-send-email-pankaj.dubey@samsung.com>
 <1394676847-3392-1-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394676847-3392-1-git-send-email-pankaj.dubey@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When used 64bit compiler GCC warns as
> drivers/mfd/sec-core.c:199:10: warning:
> cast from pointer to integer of different size [-Wpointer-to-int-cast]
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---

When submitting multiple versions, it's really helpful to keep a
simple, bullet-point change log here. It aids the review process and
omits the requirement to keep the history of every patch submittion in
a Maintainer's head.

>  drivers/mfd/sec-core.c           |    6 +++---
>  include/linux/mfd/samsung/core.h |    2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)

Patch looks good now. Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
