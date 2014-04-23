Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaDWLu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:50:26 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:60516 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaDWLuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:50:23 -0400
Date: Wed, 23 Apr 2014 12:50:17 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Anton Vorontsov <anton@enomsg.org>, Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>, ajaykumar.rs@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/5] mfd: tps65090: Stop caching most registers
Message-ID: <20140423115017.GN21613@lee--X1>
References: <1397689950-1568-1-git-send-email-dianders@chromium.org>
 <1397689950-1568-4-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397689950-1568-4-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Nearly all of the registers in tps65090 combine control bits and
> status bits.  Turn off caching of all registers except the select few
> that can be cached.
> 
> In order to avoid adding more duplicate #defines, we also move some
> register offset definitions to the mfd driver (and resolve
> inconsistent names).
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v3: None
> Changes in v2:
> - Leave cache on for the registers that can be cached.
> - Move register offsets to mfd header file.
> 
>  drivers/mfd/tps65090.c           | 27 ++++++++++++++-------------
>  drivers/power/tps65090-charger.c | 11 -----------
>  include/linux/mfd/tps65090.h     | 14 ++++++++++++++
>  3 files changed, 28 insertions(+), 24 deletions(-)

Applied now, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
