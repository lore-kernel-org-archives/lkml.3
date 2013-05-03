Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762502Ab3ECNlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 09:41:16 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:52139 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762411Ab3ECNlO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 09:41:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130503111537.GH24153@gmail.com>
References: <1367509690-24022-1-git-send-email-lee.jones@linaro.org>
	<1367509690-24022-3-git-send-email-lee.jones@linaro.org>
	<20130503111537.GH24153@gmail.com>
Date: Fri, 3 May 2013 15:41:14 +0200
Message-ID: <CACRpkdZUDFakgYbUsbm6y9G0TqNr2z8U-f3Y1T6vNR1+CvLpKg@mail.gmail.com>
Subject: Re: [PATCH 2/4 v2] mfd: ab8500-gpadc: Suppress 'ignoring
 regulator_enable() return value' warning
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 1:15 PM, Lee Jones <lee.jones@linaro.org> wrote:

> drivers/mfd/ab8500-gpadc.c: In function ‘ab8500_gpadc_resume’:
> drivers/mfd/ab8500-gpadc.c:911:18: warning: ignoring return value of
>         ‘regulator_enable’, declared with attribute warn_unused_result
>         [-Wunused-result]
>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
