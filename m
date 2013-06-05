Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab3FEIpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 04:45:07 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:46375 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab3FEIpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:45:01 -0400
MIME-Version: 1.0
In-Reply-To: <1370349382-20914-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1370349382-20914-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1370349382-20914-4-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 5 Jun 2013 14:15:00 +0530
Message-ID: <CAKohpo=JF1hBiv6dhHaQ=NK2tgGmLqw_hQqHVoOGQZFZ7FL+wg@mail.gmail.com>
Subject: Re: [PATCH v1 3/4] dma: dw: split driver to library part and platform code
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 June 2013 18:06, Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> To simplify the driver development let's split driver to library and platform
> code parts. It helps us to add PCI driver in future.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/Makefile                      |   2 +-
>  drivers/dma/dw/Kconfig                    |   8 +-
>  drivers/dma/dw/Makefile                   |   6 +-
>  drivers/dma/dw/{dw_dmac.c => core.c}      | 309 ++++--------------------------
>  drivers/dma/dw/internal.h                 |  74 +++++++
>  drivers/dma/dw/platform.c                 | 308 +++++++++++++++++++++++++++++
>  drivers/dma/dw/{dw_dmac_regs.h => regs.h} |   1 +
>  7 files changed, 428 insertions(+), 280 deletions(-)
>  rename drivers/dma/dw/{dw_dmac.c => core.c} (85%)
>  create mode 100644 drivers/dma/dw/internal.h
>  create mode 100644 drivers/dma/dw/platform.c
>  rename drivers/dma/dw/{dw_dmac_regs.h => regs.h} (99%)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
