Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933529AbaFINbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:31:12 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:33439 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222AbaFINbK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:31:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: randconfig build error with next-20140604, in drivers/i2c/muxes/i2c-mux-pca954x.c
Date: Mon, 09 Jun 2014 15:31:40 +0200
Message-ID: <14609786.lXROpz1lS8@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.20-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACRpkdZO_vE1VnJ6=gEdX8P-qNADsskJkMOdaRDg-TabTSySCQ@mail.gmail.com>
References: <CA+r1Zhi9Qd4aZ2WJ02K4Gv=zg7QvG+r=t2VpiXRKXcYRc1vt=A@mail.gmail.com> <CACRpkdZO_vE1VnJ6=gEdX8P-qNADsskJkMOdaRDg-TabTSySCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 June 2014 15:12:01 Linus Walleij wrote:
> On Wed, Jun 4, 2014 at 6:44 PM, Jim Davis <jim.epost@gmail.com> wrote:
> > Building with the attached random configuration file,
> > 
> > drivers/i2c/muxes/i2c-mux-pca954x.c: In function ‘pca954x_probe’:
> > drivers/i2c/muxes/i2c-mux-pca954x.c:204:2: error: implicit declaration
> > of function ‘devm_gpiod_get’ [-Werror=implicit-function-declaration]
> > 
> >   gpio = devm_gpiod_get(&client->dev, "reset");
> >   ^
> > 
> > drivers/i2c/muxes/i2c-mux-pca954x.c:204:7: warning: assignment makes
> > pointer from integer without a cast [enabled by default]
> > 
> >   gpio = devm_gpiod_get(&client->dev, "reset");
> >   
> >        ^
> > 
> > drivers/i2c/muxes/i2c-mux-pca954x.c:206:3: error: implicit declaration
> > of function ‘gpiod_direction_output’
> > [-Werror=implicit-function-declaration]
> > 
> >    gpiod_direction_output(gpio, 0);
> >    ^
> > 
> > cc1: some warnings being treated as errors
> > make[3]: *** [drivers/i2c/muxes/i2c-mux-pca954x.o] Error 1
> 
> I've sent a patch for this to Wolfram and the i2c discuss list.

https://git.kernel.org/cgit/linux/kernel/git/wsa/linux.git/commit/?h=i2c/for-next&id=642653d16a0f8e78b7a25d930b62aa771ebc939c

-- 
Regards,

Laurent Pinchart

