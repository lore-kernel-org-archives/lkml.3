Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaDWLvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:51:13 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:59252 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaDWLvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:51:08 -0400
Date: Wed, 23 Apr 2014 12:51:02 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Anton Vorontsov <anton@enomsg.org>, Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>, ajaykumar.rs@samsung.com,
        linux-samsung-soc@vger.kernel.org, Simon Glass <sjg@chromium.org>,
        Michael Spang <spang@chromium.org>, Sean Paul <seanpaul@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/5] regulator: tps65090: Allow setting the
 overcurrent wait time
Message-ID: <20140423115102.GO21613@lee--X1>
References: <1397689950-1568-1-git-send-email-dianders@chromium.org>
 <1397689950-1568-5-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397689950-1568-5-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The tps65090 regulator allows you to specify how long you want it to
> wait before detecting an overcurrent condition.  Allow specifying that
> through the device tree (or through platform data).
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Simon Glass <sjg@chromium.org>
> Signed-off-by: Michael Spang <spang@chromium.org>
> Signed-off-by: Sean Paul <seanpaul@chromium.org>
> ---
> Changes in v3:
> - Fixed kernel-doc notation for return
> 
> Changes in v2:
> - Separated the overcurrent and retries changes into two patches.
> - Now set overcurrent at probe time since it doesn't change.
> 
>  .../devicetree/bindings/regulator/tps65090.txt     |  4 ++
>  drivers/regulator/tps65090-regulator.c             | 56 ++++++++++++++++++++++
>  include/linux/mfd/tps65090.h                       |  5 ++
>  3 files changed, 65 insertions(+)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
