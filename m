Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763385Ab3DCVgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 17:36:22 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:58424 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760497Ab3DCVgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 17:36:21 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdar=xD34yaMP2gOfUPkpxOhDymS6zTedKOEW7j2DNHusA@mail.gmail.com>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
	<1364908916-29803-4-git-send-email-lee.jones@linaro.org>
	<CACRpkdar=xD34yaMP2gOfUPkpxOhDymS6zTedKOEW7j2DNHusA@mail.gmail.com>
Date: Wed, 3 Apr 2013 23:36:20 +0200
Message-ID: <CACRpkda08Joe9aXRgYDUs622GELL+O1vZSnzzCBa++m1zZZi=g@mail.gmail.com>
Subject: Re: [PATCH 4/9] ARM: ux500: Move Snowball's thermal DT node into
 existing PRCMU one
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 10:38 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Apr 2, 2013 at 3:21 PM, Lee Jones <lee.jones@linaro.org> wrote:
>
>> When the thermal DT node was inserted a new PRCMU node was created;
>> however, one already exists in the Snowball DTS file. Here we
>> amalgamate the two into a single consolidated node.
>>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>
> Patch applied.

After applying this I get this:

  DTC     arch/arm/boot/dts/snowball.dtb
Error: /home/elinwal/linux-stericsson/arch/arm/boot/dts/snowball.dts:351.3-352.1
syntax error
FATAL ERROR: Unable to parse input tree
make[3]: *** [arch/arm/boot/dts/snowball.dtb] Error 1
make[2]: *** [dtbs] Error 2
make[1]: *** [sub-make] Error 2
make[1]: Leaving directory `/home/elinwal/linux-stericsson'
make: *** [build-dtbs] Error 2

Does not appear prior to applying patch.

It doesn't quiet apply cleanly either, what is this based on?

Yours,
Linus Walleij
