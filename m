Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966169AbaFRLVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 07:21:40 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:53495 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933954AbaFRLVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 07:21:38 -0400
Date: Wed, 18 Jun 2014 12:21:32 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v2] ARM: stih41x: Rename stih416-b2020-revE.dts to
 stih416-b2020e.dts
Message-ID: <20140618112132.GE8300@lee--X1>
References: <1403087508-6710-1-git-send-email-lee.jones@linaro.org>
 <20140618105438.GC8300@lee--X1>
 <53A1734D.7000606@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53A1734D.7000606@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Maxime Coquelin wrote:

> Hi Lee,
> 
> On 06/18/2014 12:54 PM, Lee Jones wrote:
> >Two reasons for this rename.  Firstly, it removes the camel case
> >convention which isn't used by any other platform and secondly it
> >matches the naming convention for the internal kernel, which can
> >become annoying when flipping between the two.
> >
> >Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
> 
> It will be part of the STi pull-request for 3.16 fixes.

Thanks for taking the patch. :)

Just a quick side note.  As a maintainer, if you're going to take the
patch there's no requirement to publicly Ack it.  Just let the
submitter know that you've applied it to your tree.

I use Acks for 2 things; when a patch touches code that I maintain,
but is going in via a different tree, or as a marker if there is some
reason I can't apply it to my tree right away (waiting on dependencies
etc), but equally do not wish to review the same patch twice.

> >---
> >v1 -> v2: Appropriate change to the Makefile.
> >---
> >  arch/arm/boot/dts/Makefile                                       | 2 +-
> >  arch/arm/boot/dts/{stih416-b2020-revE.dts => stih416-b2020e.dts} | 0
> >  2 files changed, 1 insertion(+), 1 deletion(-)
> >  rename arch/arm/boot/dts/{stih416-b2020-revE.dts => stih416-b2020e.dts} (100%)
> >
> >diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> >index 5986ff6..adb5ed9 100644
> >--- a/arch/arm/boot/dts/Makefile
> >+++ b/arch/arm/boot/dts/Makefile
> >@@ -357,7 +357,7 @@ dtb-$(CONFIG_ARCH_STI)+= stih407-b2120.dtb \
> >         stih415-b2020.dtb \
> >         stih416-b2000.dtb \
> >         stih416-b2020.dtb \
> >-       stih416-b2020-revE.dtb
> >+       stih416-b2020e.dtb
> >  dtb-$(CONFIG_MACH_SUN4I) += \
> >         sun4i-a10-a1000.dtb \
> >         sun4i-a10-cubieboard.dtb \
> >diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020e.dts
> >similarity index 100%
> >rename from arch/arm/boot/dts/stih416-b2020-revE.dts
> >rename to arch/arm/boot/dts/stih416-b2020e.dts
> >

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
