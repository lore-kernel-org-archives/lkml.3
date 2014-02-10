Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaBJP4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:56:35 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:55315 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbaBJP4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:56:33 -0500
Date: Mon, 10 Feb 2014 15:56:28 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Laszlo Papp <lpapp@kde.org>, Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mfd: MAX6650/6651 support
Message-ID: <20140210155628.GA26997@lee--X1>
References: <1391859219-3102-1-git-send-email-lpapp@kde.org>
 <CAK9yfHx2W3KXzBJavpDwXqBUxM8Uw6tWLRGBLjUq1jS_yWYw-Q@mail.gmail.com>
 <20140210122129.GA23053@lee--X1>
 <CAK9yfHyBRvr5fDCiCsNWV2q83PDsY=b1H3ocmk4pQ96m5m0cHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK9yfHyBRvr5fDCiCsNWV2q83PDsY=b1H3ocmk4pQ96m5m0cHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> > +#include <linux/device.h>
> >> > +#include <linux/mfd/core.h>
> >> > +#include <linux/module.h>
> >> > +#include <linux/i2c.h>
> >>
> >> Please arrange these alphabetically.
> >
> > Why?
> 
> 1. It makes it easier to avoid adding duplicate includes.
> 2. Code looks more ordered/organized.
> 3. Prevents further clean up patches arranging them so :)

I wouldn't accept any patches doing such worthless things. ;)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
