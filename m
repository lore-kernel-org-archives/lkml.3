Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab3HUAbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:31:47 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:38408 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3HUAbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:31:46 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1374243229-8585-6-git-send-email-lee.jones@linaro.org>
References: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
	<1374243229-8585-6-git-send-email-lee.jones@linaro.org>
Date: Tue, 20 Aug 2013 17:31:45 -0700
Message-ID: <CAOesGMgd51g7WAkQu+ckT-=skKuMyj19nJkHxh+YmGSBhSL+Vg@mail.gmail.com>
Subject: Re: [PATCH 05/13] ARM: ux500: Apply a ste-* prefix onto snowball.dts
From: Olof Johansson <olof@lixom.net>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 7:13 AM, Lee Jones <lee.jones@linaro.org> wrote:
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/{snowball.dts => ste-snowball.dts} | 0
>  1 file changed, 0 insertions(+), 0 deletions(-)
>  rename arch/arm/boot/dts/{snowball.dts => ste-snowball.dts} (100%)
>
> diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
> similarity index 100%
> rename from arch/arm/boot/dts/snowball.dts
> rename to arch/arm/boot/dts/ste-snowball.dts

Grmbl, grmbl, grmbl. This now breaks any script that knows to use
snowball.dtb. :(

It's good to get the prefixes added, but it's annoying to have to deal
with both during an overlap period. Maybe generate both dtb filenames
for a while but rename the source?


-Olof
