Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679Ab3GPDcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 23:32:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49193 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab3GPDcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 23:32:41 -0400
Message-ID: <1373945380.7549.26.camel@marge.simpson.net>
Subject: Re: [PATCH 2/3] video: hx8357: Make IM pins optional
From: Mike Galbraith <bitbucket@online.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Maxime Ripard'" <maxime.ripard@free-electrons.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Alexandre Belloni'" <alexandre.belloni@free-electrons.com>,
        hector.palacios@digi.com,
        "'Thomas Petazzoni'" <thomas@free-electrons.com>,
        plagnioj@jcrosoft.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org
Date: Tue, 16 Jul 2013 05:29:40 +0200
In-Reply-To: <003501ce81be$4a945ed0$dfbd1c70$@samsung.com>
References: <1373902022-20439-1-git-send-email-maxime.ripard@free-electrons.com>
	 <1373902022-20439-3-git-send-email-maxime.ripard@free-electrons.com>
	 <003501ce81be$4a945ed0$dfbd1c70$@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:tmNHWYNUU0JTeeRr5BJcQs684Z1QuJVqM2EQKYRTP2H
 YZZ9MYGvCanwlzVY0513RyxCc73DvALPFV+eE++tsmphYo/mYC
 +E/mGDaXekgCNlgQsTlMrrxpd25y3Y5GlwHpGne3nxTDh35O4u
 1v24xHlgw9HZobxOhFJHYgB0Dh4/2Y/YtIkHQXQc4Gmf2O1fxk
 ES/QE7nk9ulZvgrLHkcuS4Igri3GRvoMYGBRk4aEW2WX1nhPUD
 StEMThgvX2W/lNjC5o622EOY88A9lmlm9TDZnyAcPaQqd9G7u1
 7l+sNckwl4hOGXzCqv5AoxdOSgG2i73+rgUivdlZTvH+W+Fdmc
 61xTBJ/DcJ28WO4mavRugXt3YoIlowO58DZn1yxoRnTaCVUUbD
 yPNxd8l3eiCXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 09:49 +0900, Jingoo Han wrote: 
> On Tuesday, July 16, 2013 12:27 AM, Maxime Ripard wrote:

> > +
> > +			ret = devm_gpio_request_one(&spi->dev, lcd->im_pins[i],
> > +						    GPIOF_OUT_INIT_LOW, "im_pins");
> 
> This makes a checkpatch warning such as 'WARNING: line over 80 characters'.
> How about the following?
> 
> 			ret = devm_gpio_request_one(&spi->dev, lcd->im_pins[i],
> 						GPIOF_OUT_INIT_LOW, "im_pins");

IIRC, some maintainers gripe (davem?) when they see such alignment,
preferring the original arg below arg alignment vs strict 80 column.

-Mike

