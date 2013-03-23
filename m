Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3CWGrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 02:47:15 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:44128 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3CWGrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 02:47:14 -0400
MIME-Version: 1.0
In-Reply-To: <1363963401-7924-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1363963401-7924-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1363963401-7924-3-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Sat, 23 Mar 2013 12:17:13 +0530
Message-ID: <CAKohpo=Vk1j1iPEBMPLukhuuRkBaAQD+XErTm62+XPwWDcLAeA@mail.gmail.com>
Subject: Re: [PATCH 2/4] dw_dmac: rename DT related methods to reflect their belonging
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 March 2013 20:13, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Since we will have not only DT cases in future let's rename DT related methods
> to reflect their belonging.
>
> The rename was done as follows:
>         struct dw_dma_filter_args       -> struct dw_dma_of_filter_args
>         dw_dma_generic_filter()         -> dw_dma_of_filter()
>         dw_dma_xlate()                  -> dw_dma_of_xlate()
>         dw_dma_id_table                 -> dw_dma_of_id_table
>
> There is no functional change.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
