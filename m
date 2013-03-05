Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab3CEBrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 20:47:09 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:55607 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290Ab3CEBrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 20:47:07 -0500
MIME-Version: 1.0
In-Reply-To: <1362388174-3435-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1362388174-3435-4-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 5 Mar 2013 09:47:06 +0800
Message-ID: <CAKohponRYJi63XqLsDdZ+zqT6_SLLyMRR+PwNsbQ2cD--9gdxw@mail.gmail.com>
Subject: Re: [PATCH 03/10] dmatest: create dmatest_info to keep test parameters
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
> The proposed change will remove usage of the module parameters as global
> variables. In future it helps to run different test cases sequentially.
>
> The patch introduces the run_threaded_test() and stop_threaded_test() functions
> that could be used later outside of dmatest_init, dmatest_exit scope.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dmatest.c | 160 +++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 113 insertions(+), 47 deletions(-)
>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
