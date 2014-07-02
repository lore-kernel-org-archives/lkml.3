Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbaGBQGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:06:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38379 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaGBQGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:06:39 -0400
Message-ID: <1404317194.4109.13.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v2 0/4] Add reset controllers for STiH407 SoC
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org
Date: Wed, 02 Jul 2014 18:06:34 +0200
In-Reply-To: <1404310129-14667-1-git-send-email-peter.griffin@linaro.org>
References: <1404310129-14667-1-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Am Mittwoch, den 02.07.2014, 15:08 +0100 schrieb Peter Griffin:
> This series adds reset controller support for the STiH407 SoC.
> 
> Changes since v1
>  - Update copyright to 2014
>  - Add const qualifier
>  - Fix various whitespace issues
>  - Remove THIS_OWNER
>  - Move DT documentation into separate patch
> 
> Peter Griffin (4):
>   reset: stih407: Add softreset, powerdown and picophy controllers
>   reset: sti: Document sti-picophyreset controllers bindings.
>   ARM: sti: Add STiH407 Kconfig entry to select STIH407_RESET
>   ARM: sti: Add STiH407 reset controller support.
> 
>  .../bindings/reset/st,sti-picophyreset.txt         |  42 ++++++
>  arch/arm/boot/dts/stih407.dtsi                     |  16 +++
>  arch/arm/mach-sti/Kconfig                          |  10 ++
>  drivers/reset/sti/Kconfig                          |   4 +
>  drivers/reset/sti/Makefile                         |   1 +
>  drivers/reset/sti/reset-stih407.c                  | 158 +++++++++++++++++++++
>  .../dt-bindings/reset-controller/stih407-resets.h  |  61 ++++++++
>  7 files changed, 292 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt
>  create mode 100644 drivers/reset/sti/reset-stih407.c
>  create mode 100644 include/dt-bindings/reset-controller/stih407-resets.h

Looks good to me now.

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

