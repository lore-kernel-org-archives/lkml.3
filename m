Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974Ab3CMRUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:20:39 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:43939 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab3CMRUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:20:36 -0400
MIME-Version: 1.0
In-Reply-To: <1363195044-15715-1-git-send-email-dianders@chromium.org>
References: <1363195044-15715-1-git-send-email-dianders@chromium.org>
Date: Wed, 13 Mar 2013 10:20:34 -0700
X-Google-Sender-Auth: yyc6g1NabzUqlqvKznbthMHjuRI
Message-ID: <CAD=FV=W9KF4OM9VzMse4rRnKsph2h2izLKHptvffz4gRkFmBNw@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: add usb 2.0 clock references to device tree
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Padmavathi Venna <padma.v@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh...

On Wed, Mar 13, 2013 at 10:17 AM, Doug Anderson <dianders@chromium.org> wrote:
> This is a fixup to two device tree nodes that have already landed but
> without clock nodes since the transition to common clock happened at
> the same time.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Please forgive my fat finger and see the version with the updated
description: "[PATCH] ARM: dts: add usb 2.0 clock references to
exynos5250 device tree".  There is no difference other than the title.

-Doug
