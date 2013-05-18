Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab3ERCLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:11:42 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:60077 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab3ERCLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:11:41 -0400
MIME-Version: 1.0
In-Reply-To: <1368791235-10242-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1368791235-10242-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Sat, 18 May 2013 07:41:40 +0530
X-Google-Sender-Auth: 7kSD28Ua5GyHlN0MK64V4w18Y1E
Message-ID: <CAOh2x=kcwhaT+0d5G+1L9__fvMAd3AXrvo2z+bYEFhRUJ13rfg@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: print message if IO resource is not found
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 5:17 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> devm_ioremap_resource() will print a message if resource is not found.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Log and subject should be something like this.

https://patchwork.kernel.org/patch/2549091/
