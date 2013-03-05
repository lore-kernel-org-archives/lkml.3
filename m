Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949Ab3CEBnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 20:43:08 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:35498 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab3CEBnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 20:43:06 -0500
MIME-Version: 1.0
In-Reply-To: <1362388174-3435-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1362388174-3435-3-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 5 Mar 2013 09:43:04 +0800
Message-ID: <CAKohponTN+9VhDRonXewut27xTvoDFj+n+v1kQpAuHHiV8wzZg@mail.gmail.com>
Subject: Re: [PATCH 02/10] dmatest: allocate memory for pq_coefs from heap
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
> This will help in future to hide a global variable usage.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dmatest.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
