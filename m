Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323AbaFINME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:12:04 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:34910 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277AbaFINMC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:12:02 -0400
MIME-Version: 1.0
In-Reply-To: <CA+r1Zhi9Qd4aZ2WJ02K4Gv=zg7QvG+r=t2VpiXRKXcYRc1vt=A@mail.gmail.com>
References: <CA+r1Zhi9Qd4aZ2WJ02K4Gv=zg7QvG+r=t2VpiXRKXcYRc1vt=A@mail.gmail.com>
Date: Mon, 9 Jun 2014 15:12:01 +0200
Message-ID: <CACRpkdZO_vE1VnJ6=gEdX8P-qNADsskJkMOdaRDg-TabTSySCQ@mail.gmail.com>
Subject: Re: randconfig build error with next-20140604, in drivers/i2c/muxes/i2c-mux-pca954x.c
From: Linus Walleij <linus.walleij@linaro.org>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 6:44 PM, Jim Davis <jim.epost@gmail.com> wrote:

> Building with the attached random configuration file,
>
> drivers/i2c/muxes/i2c-mux-pca954x.c: In function ‘pca954x_probe’:
> drivers/i2c/muxes/i2c-mux-pca954x.c:204:2: error: implicit declaration
> of function ‘devm_gpiod_get’ [-Werror=implicit-function-declaration]
>   gpio = devm_gpiod_get(&client->dev, "reset");
>   ^
> drivers/i2c/muxes/i2c-mux-pca954x.c:204:7: warning: assignment makes
> pointer from integer without a cast [enabled by default]
>   gpio = devm_gpiod_get(&client->dev, "reset");
>        ^
> drivers/i2c/muxes/i2c-mux-pca954x.c:206:3: error: implicit declaration
> of function ‘gpiod_direction_output’
> [-Werror=implicit-function-declaration]
>    gpiod_direction_output(gpio, 0);
>    ^
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/i2c/muxes/i2c-mux-pca954x.o] Error 1

I've sent a patch for this to Wolfram and the i2c discuss list.

Yours,
Linus Walleij
