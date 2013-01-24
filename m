Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab3AXEoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 23:44:17 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:48181 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3AXEoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 23:44:07 -0500
MIME-Version: 1.0
In-Reply-To: <1358955452-20960-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1358955452-20960-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1358955452-20960-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 24 Jan 2013 10:07:42 +0530
X-Google-Sender-Auth: W8Nx_5vAZBVIEnfRdQmU6FL92Fw
Message-ID: <CAOh2x=mwXk8aFbAEBdvWufC=0N-m2vA98-R26j6Wc-69PU24uA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] dw_dmac: remove unnecessary tx_list field in dw_dma_chan
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 9:07 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The soft LLP mode is working for active descriptor only. So, we do not need to
> have a copy of its pointer.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
