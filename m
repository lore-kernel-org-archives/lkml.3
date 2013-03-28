Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab3C1Cbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 22:31:45 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:58159 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab3C1Cbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 22:31:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130327194807.GB11086@roeck-us.net>
References: <1364368412-12810-1-git-send-email-hongbo.zhang@linaro.org>
	<1364368412-12810-6-git-send-email-hongbo.zhang@linaro.org>
	<20130327194807.GB11086@roeck-us.net>
Date: Thu, 28 Mar 2013 10:31:42 +0800
Message-ID: <CAJLyvQwf+izpBnBWshu1ggQMsuQ03iiSsC4TiM9BOWg2LZFhhg@mail.gmail.com>
Subject: Re: [PATCH v7 5/5] hwmon: add ST-Ericsson ABX500 hwmon driver
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: khali@linux-fr.org, lm-sensors@lm-sensors.org, cbou@mail.ru,
        dwmw2@infradead.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@linaro.org,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 March 2013 03:48, Guenter Roeck <linux@roeck-us.net> wrote:
> On Wed, Mar 27, 2013 at 03:13:32PM +0800, Hongbo Zhang wrote:
>> Each of ST-Ericsson X500 chip set series consists of both ABX500 and DBX500
>> chips. This is ABX500 hwmon driver, where the abx500.c is a common layer for
>> all ABX500s, and the ab8500.c is specific for AB8500 chip. Under this designed
>> structure, other chip specific files can be added simply using the same common
>> layer abx500.c.
>>
>> Signed-off-by: Hongbo Zhang <hongbo.zhang@linaro.org>
>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Thank you very much, Guenter.
