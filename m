Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3KRTBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:01:51 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:48455 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3KRTBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 14:01:41 -0500
Date: Mon, 18 Nov 2013 19:01:36 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "dbasehore ." <dbasehore@chromium.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, devicetree@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] mfd: cros ec: spi: Increase EC transaction delay
Message-ID: <20131118190136.GS13640@lee--X1>
References: <1384770649-8593-1-git-send-email-treding@nvidia.com>
 <1384770649-8593-2-git-send-email-treding@nvidia.com>
 <20131118104343.GG13640@lee--X1>
 <CAGAzgsrUedg7pGXpS6VaWkHeYjvcyio7byeEZ=88t3U1XzbsPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGAzgsrUedg7pGXpS6VaWkHeYjvcyio7byeEZ=88t3U1XzbsPQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013, dbasehore . wrote:

> We haven't had any issues with this patch and we've had it in our tree
> for a while.
> 
> I also stress tested the patch by repeatedly reading over the spi a lot.

Okay, thanks for letting me know.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
