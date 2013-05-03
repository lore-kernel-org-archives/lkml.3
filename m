Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762483Ab3ECNzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 09:55:16 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46045 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762035Ab3ECNzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 09:55:15 -0400
Date: Fri, 3 May 2013 14:55:09 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/4 v2] mfd: ab8500-gpadc: Suppress 'ignoring
 regulator_enable() return value' warning
Message-ID: <20130503135509.GL24153@gmail.com>
References: <1367509690-24022-1-git-send-email-lee.jones@linaro.org>
 <1367509690-24022-3-git-send-email-lee.jones@linaro.org>
 <20130503111537.GH24153@gmail.com>
 <CACRpkdZUDFakgYbUsbm6y9G0TqNr2z8U-f3Y1T6vNR1+CvLpKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZUDFakgYbUsbm6y9G0TqNr2z8U-f3Y1T6vNR1+CvLpKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 May 2013, Linus Walleij wrote:

> On Fri, May 3, 2013 at 1:15 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > drivers/mfd/ab8500-gpadc.c: In function ‘ab8500_gpadc_resume’:
> > drivers/mfd/ab8500-gpadc.c:911:18: warning: ignoring return value of
> >         ‘regulator_enable’, declared with attribute warn_unused_result
> >         [-Wunused-result]
> >
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Yours,
> Linus Walleij

Nice, thanks. I'm applying this now.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
