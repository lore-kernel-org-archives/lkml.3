Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab3FEJmC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:42:02 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:37274 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab3FEJmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:42:00 -0400
MIME-Version: 1.0
In-Reply-To: <1370349382-20914-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1370349382-20914-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1370349382-20914-5-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 5 Jun 2013 15:11:59 +0530
Message-ID: <CAKohpomqvMZ3gFrQpsq6iorHMz+4M2zwQ69RavPuqF1Z54cD8Q@mail.gmail.com>
Subject: Re: [PATCH v1 4/4] dma: dw: add PCI part of the driver
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
> This is the PCI part of the DesignWare DMAC driver. The controller is usually
> used in the Intel hardware such as Intel Medfield.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw/Kconfig  |   9 +++++
>  drivers/dma/dw/Makefile |   3 ++
>  drivers/dma/dw/pci.c    | 101 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 113 insertions(+)
>  create mode 100644 drivers/dma/dw/pci.c

Looks fine.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
