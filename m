Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964978AbaGBQ7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:59:34 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:53891 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192AbaGBQ7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:59:31 -0400
Date: Wed, 2 Jul 2014 17:59:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Peter Griffin <peter.griffin@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Add reset controllers for STiH407 SoC
Message-ID: <20140702165924.GB17665@lee--X1>
References: <1404310129-14667-1-git-send-email-peter.griffin@linaro.org>
 <1404317194.4109.13.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404317194.4109.13.camel@paszta.hi.pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2014, Philipp Zabel wrote:

> Hi Peter,
> 
> Am Mittwoch, den 02.07.2014, 15:08 +0100 schrieb Peter Griffin:
> > This series adds reset controller support for the STiH407 SoC.
> > 
> > Changes since v1
> >  - Update copyright to 2014
> >  - Add const qualifier
> >  - Fix various whitespace issues
> >  - Remove THIS_OWNER
> >  - Move DT documentation into separate patch
> > 
> > Peter Griffin (4):
> >   reset: stih407: Add softreset, powerdown and picophy controllers
> >   reset: sti: Document sti-picophyreset controllers bindings.
> >   ARM: sti: Add STiH407 Kconfig entry to select STIH407_RESET
> >   ARM: sti: Add STiH407 reset controller support.
> > 
> >  .../bindings/reset/st,sti-picophyreset.txt         |  42 ++++++
> >  arch/arm/boot/dts/stih407.dtsi                     |  16 +++
> >  arch/arm/mach-sti/Kconfig                          |  10 ++
> >  drivers/reset/sti/Kconfig                          |   4 +
> >  drivers/reset/sti/Makefile                         |   1 +
> >  drivers/reset/sti/reset-stih407.c                  | 158 +++++++++++++++++++++
> >  .../dt-bindings/reset-controller/stih407-resets.h  |  61 ++++++++
> >  7 files changed, 292 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt
> >  create mode 100644 drivers/reset/sti/reset-stih407.c
> >  create mode 100644 include/dt-bindings/reset-controller/stih407-resets.h
> 
> Looks good to me now.
> 
> Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

Do you have a tree for Reset?  If not, which route do these patches
normally follow?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
