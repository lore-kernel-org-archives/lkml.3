Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbaGIMSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:18:41 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:36251 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaGIMSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:18:39 -0400
MIME-Version: 1.0
In-Reply-To: <1401899424-1365-2-git-send-email-peter.griffin@linaro.org>
References: <1401899424-1365-1-git-send-email-peter.griffin@linaro.org>
	<1401899424-1365-2-git-send-email-peter.griffin@linaro.org>
Date: Wed, 9 Jul 2014 14:18:39 +0200
Message-ID: <CAPDyKFoFNaFpDTVvMF3fbkrgYwUY1_hcbic89JyJzezFDRtN_w@mail.gmail.com>
Subject: Re: [PATCH v3 01/10] mmc: sdhci-st: Intial support for ST SDHCI controller
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        kernel@stlinux.com, linux-mmc <linux-mmc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 June 2014 18:30, Peter Griffin <peter.griffin@linaro.org> wrote:
> This platform driver adds initial support for the SDHCI host controller
> found on STMicroelectronics SoCs.
>
> It has been tested on STiH41x b2020 platforms currently.
>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Thanks! Applied for next.

Kind regards
Uffe
