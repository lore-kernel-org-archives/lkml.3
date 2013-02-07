Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab3BGN3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:29:07 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:44668 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936Ab3BGN3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:29:04 -0500
MIME-Version: 1.0
In-Reply-To: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 7 Feb 2013 18:58:51 +0530
X-Google-Sender-Auth: eSaNNF-2Kr9lPZoRS1Tysgncwro
Message-ID: <CAOh2x=k0nnFphKSoOFpX7F8x6ERoFSSg6HusNgzKonSyhVsBDw@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: adjust slave_id accordingly to request line base
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 4:34 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On some hardware configurations we have got the request line with the offset.
> The patch introduces convert_slave_id() helper for that cases. The request line
> base is got from the platform device resources provided by the IORESOURCE_DMA
> type.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
