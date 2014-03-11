Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbaCKLUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:20:35 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44734 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbaCKLUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:20:34 -0400
Date: Tue, 11 Mar 2014 11:20:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@st.com
Subject: Re: [PATCH 2/3] ARM: STi: stih416-b2020: Explicitly include STiH416
 Pinctrl bindings
Message-ID: <20140311112027.GD21216@lee--X1>
References: <1394533324-20299-1-git-send-email-lee.jones@linaro.org>
 <1394533324-20299-2-git-send-email-lee.jones@linaro.org>
 <531EEADF.5060001@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <531EEADF.5060001@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >At the moment we're relying on inheriting them from DTSI files which
> >we're including Ideally we should be specifying these for ourselves.
> >
> >Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >---
> >  arch/arm/boot/dts/stih416-b2020-revE.dts | 1 +
> >  1 file changed, 1 insertion(+)
> >
> >diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020-revE.dts
> >index bcb9d00..4168b019 100644
> >--- a/arch/arm/boot/dts/stih416-b2020-revE.dts
> >+++ b/arch/arm/boot/dts/stih416-b2020-revE.dts
> >@@ -8,6 +8,7 @@
> >   */
> >  /dts-v1/;
> >  #include "stih416.dtsi"
> >+#include "stih416-pinctrl.dtsi"
> Isn't this file already included in stih416.dtsi?

It is, but it's being inherited. I'm unsure if the DT rules are
different, but in *.c files #includes should be added explicitly in
the file they are used.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
