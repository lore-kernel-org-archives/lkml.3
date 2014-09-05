Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbaIEM0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:26:25 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:58534 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaIEM0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:26:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Hartmut Knaack <knaack.h@gmx.de>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Fugang Duan <B38611@freescale.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Jean Delvare <jdelvare@suse.de>, Philippe Reynes <tremyfr@yahoo.fr>,
        Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        David Collins <collinsd@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH 1/2] iio: vadc: Qualcomm SPMI PMIC voltage ADC driver
Date: Fri, 05 Sep 2014 14:26:14 +0200
Message-ID: <3495079.hWGRuSPgx7@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409919274-13419-2-git-send-email-svarbanov@mm-sol.com>
References: <1409919274-13419-1-git-send-email-svarbanov@mm-sol.com> <1409919274-13419-2-git-send-email-svarbanov@mm-sol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:UCf8tqoPfnkyQ4mcJt99npQMwrotR1FJ2s4HcbZa08o
 zlYns/w8bCVN7xrrWjdSZJ2M2JWwiRp8qcUn/luaREeTGLPGc3
 odP//uGzhXtOImrK9XxCVbcVHAMIqGQ4j5jBWC6/EfvWZTfBDT
 eYV3Z5oOecL5KObtCQDlA1pOAmxRY9zPD9SZx5g/grWvJYIZ35
 06TRLezkJkK7fTsB72zyHLJ3+v915UTIYJ+L+bEFLBsU2qAS0C
 2iVwsf22a94s0gmTCwla6MswJP6PTvztTIdPVZJLYoA8WtwMKo
 oyC6+bORLGqohkwdVI/h7p6/Bzz/+UAcNJwH+D/In2D7/aTode
 PXRIUKUc0UWE/O7qHbfs=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014 15:14:33 Stanimir Varbanov wrote:
> +       VADC_CHAN(LR_MUX1_BAT_THERM, 0)                 /* 0x30 */
> +       VADC_CHAN(LR_MUX2_BAT_ID, 0)
> +       VADC_CHAN(LR_MUX3_XO_THERM, 0)
> +       VADC_CHAN(LR_MUX4_AMUX_THM1, 0)
> +       VADC_CHAN(LR_MUX5_AMUX_THM2, 0)
> +       VADC_CHAN(LR_MUX6_AMUX_THM3, 0)
> +       VADC_CHAN(LR_MUX7_HW_ID, 0)
> +       VADC_CHAN(LR_MUX8_AMUX_THM4, 0)
> +       VADC_CHAN(LR_MUX9_AMUX_THM5, 0)
> +       VADC_CHAN(AMUX_PU1, 0)
> +       VADC_CHAN(AMUX_PU2, 0)
> +       VADC_CHAN(LR_MUX3_BUF_XO_THERM_BUF, 0)          /* 0x3c */
> +
> +       VADC_CHAN(LR_MUX1_PU1_BAT_THERM, 0)             /* 0x70 */
> +       VADC_CHAN(LR_MUX2_PU1_BAT_ID, 0)
> +       VADC_CHAN(LR_MUX3_PU1_XO_THERM, 0)
> +       VADC_CHAN(LR_MUX4_PU1_AMUX_THM1, 0)
> +       VADC_CHAN(LR_MUX5_PU1_AMUX_THM2, 0)
> +       VADC_CHAN(LR_MUX6_PU1_AMUX_THM3, 0)
> +       VADC_CHAN(LR_MUX7_PU1_AMUX_HW_ID, 0)
> +       VADC_CHAN(LR_MUX8_PU1_AMUX_THM4, 0)
> +       VADC_CHAN(LR_MUX9_PU1_AMUX_THM5, 0)
> +       VADC_CHAN(LR_MUX10_PU1_AMUX_USB_ID, 0)          /* 0x79 */
> +       VADC_CHAN(LR_MUX3_BUF_PU1_XO_THERM_BUF, 0)      /* 0x7c */
> 

These numbers all look hardware specific, so why put macros into the
device tree rather than using them directly?

If you want to make up your own macro namespace, I would suggest
using consecutive numbers and turning the above into

	...
	[LR_MUX3_BUF_XO_THERM_BUF] = VADC_CHAN(0x3c, 0),
	[LR_MUX1_PU1_BAT_THERM]    = VADC_CHAN(0x70, 0),
	[LR_MUX1_PU1_BAT_ID]       = VADC_CHAN(0x71, 0),
	...

but I don't see that really improving the DT, since you then
need to look up the values in the header rather than the data sheet.

	Arnd
