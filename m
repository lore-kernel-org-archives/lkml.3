Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbaB1Kti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:49:38 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:43324 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaB1Ktg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:49:36 -0500
Date: Fri, 28 Feb 2014 10:49:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 0/4] mfd: sec: Add support for S2MPS14
Message-ID: <20140228104927.GB31720@lee--X1>
References: <1393584104-18912-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393584104-18912-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Few days ago I sent patches adding support for S2MPS14 device to the
> sec-core/s2mps11 drivers. These patches were rather large as they covered
> multiple subsystems so I decided to split everything into smaller, separate
> patches.
> 
> The original patchset (version 3) can be found here:
> http://thread.gmane.org/gmane.linux.kernel.samsung-soc/27194/focus=1649217
> 
> This patchset is a small subset of the patchset related to the MFD core
> driver. It adds support for the S2MPS14 device only to the MFD core driver.
> I already obtained acks from Lee Jones during previous reviews.
> 
> The patchset is based on current Linus' tree *with* patch:
> mfd: sec-core: Fix possible NULL pointer dereference when i2c_new_dummy error
> (which is already in Lee Jones' MFD tree)

Can all of these patches be applied as they are?

Is anything going to break as a result?

> Krzysztof Kozlowski (4):
>   mfd: sec: Add maximum RTC register for regmap config
>   mfd: sec: Select different RTC regmaps for devices
>   mfd: sec: Use consistent S2MPS11 RTC alarm interrupt indexes
>   mfd: sec: Add support for S2MPS14
> 
>  drivers/mfd/sec-core.c              |   57 ++++++++++++-
>  drivers/mfd/sec-irq.c               |   97 ++++++++++++++++++++--
>  include/linux/mfd/samsung/core.h    |    1 +
>  include/linux/mfd/samsung/irq.h     |   31 ++++++-
>  include/linux/mfd/samsung/rtc.h     |   57 +++++++++++--
>  include/linux/mfd/samsung/s2mps14.h |  152 +++++++++++++++++++++++++++++++++++
>  6 files changed, 378 insertions(+), 17 deletions(-)
>  create mode 100644 include/linux/mfd/samsung/s2mps14.h
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
