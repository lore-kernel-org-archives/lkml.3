Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaDOQwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:52:19 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:50408 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaDOQwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:52:17 -0400
Message-ID: <534D63D7.8000803@linaro.org>
Date: Tue, 15 Apr 2014 18:52:39 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH v2] clocksource: efm32: use $vendor,$device scheme for
 compatible string
References: <1395757522-6431-1-git-send-email-u.kleine-koenig@pengutronix.de> <1395759044-10700-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1395759044-10700-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 03:50 PM, Uwe Kleine-König wrote:
> Wolfgang Sang pointed out that "efm32,$device" is non-standard. So use the
> common scheme and prefix device with "efm32-". The old compatible string
> is left in place until arch/arm/boot/dts/efm32* is fixed.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de

Applied for 3.16 (and fixed Wolfgang => Wolfram)

Thanks !

   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

