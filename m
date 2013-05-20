Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3ETJLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:11:07 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:64394 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3ETJLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:11:03 -0400
MIME-Version: 1.0
In-Reply-To: <1369036076-26660-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369036076-26660-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 20 May 2013 14:41:02 +0530
X-Google-Sender-Auth: 6Y70aYWHqOXorYPRKrfIKrAhtg8
Message-ID: <CAOh2x=nqK6O65m6DB8KUyvWZqu3TJM+4nDpFsk0SHaXZQTTCiQ@mail.gmail.com>
Subject: Re: [PATCH v2] dw_dmac: don't check resource with devm_ioremap_resource
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 1:17 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> Since v1:
>  - fix commit message to be along with other similar patches

Please always add a blank line here.

>  drivers/dma/dw_dmac.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
