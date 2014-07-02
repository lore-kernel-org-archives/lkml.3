Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaGBPlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:41:10 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:35414 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbaGBPlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:41:07 -0400
Date: Wed, 2 Jul 2014 16:40:59 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, srinivas.kandagatla@gmail.com,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH v2 1/4] reset: stih407: Add softreset, powerdown and
 picophy controllers
Message-ID: <20140702154059.GA17665@lee--X1>
References: <1404310129-14667-1-git-send-email-peter.griffin@linaro.org>
 <1404310129-14667-2-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404310129-14667-2-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2014, Peter Griffin wrote:

> This patch adds softreset, powerdown and picophy reset controllers for
> the STiH407 SoC.
> 
> With this patch three new devices are registered: -
> 1. st,stih407-powerdown
> 2. st,stih407-softreset
> 3. st,stih407-picophyreset
> 
> All three devices use system configuration registers mapped via regmap to
> perform the reset or powerdown. The powerdown controller also has
> an acknowledgement.
> 
> A separate picophy reset controller manages the different reset channels within
> the picophy, which have a different polarity to the other system softresets.
> Managing these different picophy softreset channels is necessary to correctly
> handle resuming from suspend when USB2 devices are plugged into the USB3 port.
> 
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  drivers/reset/sti/Kconfig                          |   4 +
>  drivers/reset/sti/Makefile                         |   1 +
>  drivers/reset/sti/reset-stih407.c                  | 158 +++++++++++++++++++++
>  .../dt-bindings/reset-controller/stih407-resets.h  |  61 ++++++++
>  4 files changed, 224 insertions(+)
>  create mode 100644 drivers/reset/sti/reset-stih407.c
>  create mode 100644 include/dt-bindings/reset-controller/stih407-resets.h

Looks good to me now:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
