Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbaGDMZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:25:29 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:56169 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbaGDMZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:25:27 -0400
MIME-Version: 1.0
In-Reply-To: <1404472432-24764-3-git-send-email-peter.griffin@linaro.org>
References: <1404472432-24764-1-git-send-email-peter.griffin@linaro.org>
	<1404472432-24764-3-git-send-email-peter.griffin@linaro.org>
Date: Fri, 4 Jul 2014 14:25:24 +0200
Message-ID: <CAN_we7Mqm0ScULzCSNwmb46MAQNcfckSZ9+iH_3pCfv+VTyUMg@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: dts: sti: Add st-dwc3 devicetree bindings documentation
From: Daniele Forsi <dforsi@gmail.com>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, devicetree@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, USB list <linux-usb@vger.kernel.org>,
        linux-omap@vger.kernel.org, lee.jones@linaro.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-04 13:13 GMT+02:00 Peter Griffin:

> +Required properties:
> + - compatible  : must be "st,stih407-dwc3"
> + - reg         : glue logic base address and USB syscfg ctrl register offest
> + - reg-names   : Should be "reg-glue" and "syscfg-reg".
> + - st,syscon    : should be phandle to system configuration node which
> +                 encompases the glue registers.
> + - resets       : phandle pointing to the system powerdown controller

minor knits:
s/offest/offset/
s/encompases/encompasses/
"Should" is upper case while all other lines in this block start with
a lower case letter;
two lines end with a full stop, three lines without;
colons the last lines do not align to the first three

-- 
Daniele Forsi
