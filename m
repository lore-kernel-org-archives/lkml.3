Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbaGISHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:07:41 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48132 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbaGISHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:07:31 -0400
Message-ID: <53BD84E1.4030602@codeaurora.org>
Date: Wed, 09 Jul 2014 11:07:29 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stanimir Varbanov <svarbanov@mm-sol.com>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [RFC PATCH v2 3/5] rtc: add qpnp rtc driver
References: <1404393243-7324-1-git-send-email-svarbanov@mm-sol.com> <1404393243-7324-4-git-send-email-svarbanov@mm-sol.com>
In-Reply-To: <1404393243-7324-4-git-send-email-svarbanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/14 06:14, Stanimir Varbanov wrote:
> A 32bits RTC is housed inside PMIC. The RTC driver uses QPNP
> SPMI interface to communicate with the PMIC RTC module.
>
> The RTC device is divided into two sub-peripherals:
>  - RTC read-write peripheral having basic RTC registers
>  - alarm peripheral for controlling alarm
>
> These two RTC peripherals are childrens of QPNP SPMI bus. They
> use regmap to read/write to its registers into PMIC.
>

What happened to using Josh's patch for rtc-pm8xxx.c[1]? That seems
easier than adding an entire new driver for almost the same hardware.

[1]
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/207665.html

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

