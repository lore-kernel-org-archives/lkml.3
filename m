Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaEUJMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:12:34 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:35253 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaEUJMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:12:32 -0400
Date: Wed, 21 May 2014 10:12:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patrice.chotard@st.com, kernel@stlinux.com
Subject: Re: [PATCH 3/3] ARM: sti: stih41x: Provide a proper header for this
 DTSI file
Message-ID: <20140521091227.GA6679@lee--X1>
References: <1400660415-14720-1-git-send-email-lee.jones@linaro.org>
 <1400660415-14720-3-git-send-email-lee.jones@linaro.org>
 <537C64A6.4050409@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <537C64A6.4050409@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >Also explicitly include STiH416 Clk bindings instead of relying on
> >inheriting them from other DTSI files which we happen to include.
> >
> >Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >---
> >  arch/arm/boot/dts/stih41x.dtsi | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> >diff --git a/arch/arm/boot/dts/stih41x.dtsi b/arch/arm/boot/dts/stih41x.dtsi
> >index f5b9898..32730e5 100644
> >--- a/arch/arm/boot/dts/stih41x.dtsi
> >+++ b/arch/arm/boot/dts/stih41x.dtsi
> >@@ -1,3 +1,11 @@
> >+/*
> >+ * Copyright (C) 2014 STMicroelectronics Limited.
> >+ *
> >+ * This program is free software; you can redistribute it and/or modify
> >+ * it under the terms of the GNU General Public License version 2 as
> >+ * publishhed by the Free Software Foundation.
> >+ */
> >+#include "stih416-clock.dtsi"
> 
> Nack.
> As discussed on IRC, this dtsi file is included by stih415.dtsi.
> In this case, we want to include stih415-clocks.dtsi instead.

+1 resubmitted.

> >  / {
> >  	#address-cells = <1>;
> >  	#size-cells = <1>;
> >

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
