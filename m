Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3GPKSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 06:18:50 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:38164 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3GPKSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 06:18:49 -0400
MIME-Version: 1.0
In-Reply-To: <1373889881-21075-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1373889881-21075-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 16 Jul 2013 15:48:48 +0530
X-Google-Sender-Auth: BZavY0-zAM2BXWWgLG4474CVKZA
Message-ID: <CAOh2x=k0m7tP_97=CQRXqhx-tNQPwiXwM9cbGO7SzbTSM0HQLQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] acpi-dma: fix sparse warning
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 5:34 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> This patch fixes sparse warning:
>         drivers/dma/acpi-dma.c:76:21: sparse: cast to restricted __le32
>
> Since everything in all ACPI tables is little-endian, by definition, the used
> types in practice are uXX. Thus, we have to enforce __leXX if we want to
> convert them to CPU order.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/dma/acpi-dma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

For the complete series:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
