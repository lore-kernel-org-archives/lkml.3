Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352Ab3AQIFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 03:05:50 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:47916 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab3AQIFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 03:05:48 -0500
MIME-Version: 1.0
In-Reply-To: <1358409781-27145-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1358409781-27145-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 17 Jan 2013 13:35:47 +0530
X-Google-Sender-Auth: 22auhyEOZT7nDGkWUX_ZCuHc-gw
Message-ID: <CAOh2x=kvAdpaAf11tde=tAcGc=BeVBFr8WgisKseSKoQ5NBr4w@mail.gmail.com>
Subject: Re: [PATCH v4] dw_dmac: don't exceed AHB master number in dwc_get_data_width
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 1:33 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The driver assumes that hardware has two AHB masters which might not be always
> true. In such cases we must not exceed number of the AHB masters present in the
> hardware. In the proposed scheme in this patch, we would choose the master with
> highest possible number whenever we exceed max AHB masters.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Looks good now.
