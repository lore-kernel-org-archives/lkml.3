Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbaCCH6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:58:46 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53946 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbaCCH6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:58:44 -0500
Date: Mon, 3 Mar 2014 15:58:38 +0800
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 0/5] rtc: s5m: Add support for S2MPS14
Message-ID: <20140303075838.GG4674@lee--X1>
References: <1393592408-27181-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393592408-27181-1-git-send-email-k.kozlowski@samsung.com>
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
> This patchset is a small subset of above related to the S5M RTC driver.
> It adds support for the S2MPS14 device.
> 
> These patches are rebased against Lee's "for-mfd-next" tree because they require
> changes in main MFD sec-core driver ("Add support for S2MPS14 for-mfd-next",
> which is already in Lee's "for-mfd-next" tree).

I'm happy to take this patch-set though the MFD tree and provide a
immutable branch for the RTC guys to pull from.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
