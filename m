Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab3CEJQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 04:16:12 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:55396 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab3CEJQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 04:16:10 -0500
MIME-Version: 1.0
In-Reply-To: <1362388174-3435-6-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1362388174-3435-6-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 5 Mar 2013 17:16:10 +0800
Message-ID: <CAKohpokhM-gdDMAb-f1GnoacsyXqEHqo20EkemUGrNDfw+Mw-g@mail.gmail.com>
Subject: Re: [PATCH 05/10] dmatest: split test parameters to separate structure
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 March 2013 17:09, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Better to keep test parameters separate from internal variables.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dmatest.c | 109 ++++++++++++++++++++++++++++----------------------
>  1 file changed, 62 insertions(+), 47 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Though i don't feel a real need of keeping this in separate patches.
We can have one for fixing these :)
