Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaBLIcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:32:35 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:52933 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaBLIcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:32:31 -0500
Date: Wed, 12 Feb 2014 08:32:24 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v6] mfd: MAX6650/6651 support
Message-ID: <20140212083224.GM15081@lee--X1>
References: <1392177760-17959-1-git-send-email-lpapp@kde.org>
 <CAK9yfHztuCSBSJUjc1xcf-f+O+kaKQQ=ExpWB-LoCkLoaZPfWA@mail.gmail.com>
 <CAOMwXhNp-+Fr87NxdquEOtEriqt20E4b08W8JBrKMbCqh1K6_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMwXhNp-+Fr87NxdquEOtEriqt20E4b08W8JBrKMbCqh1K6_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +       max665x->map = devm_regmap_init_i2c(i2c, &max665x_regmap_config);
> >
> > Don't you need to check the return value of devm_regmap_init_i2c?
> 
> I personally think I should. I strived for consistency though with
> other similar drivers. After this many reviews about such things, it
> seems that consistency matters here less than other projects which I
> can cope with, thanks.

The right thing to do is normally preferred.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
