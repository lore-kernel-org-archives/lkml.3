Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab3LMImR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:42:17 -0500
Received: from gloria.sntech.de ([95.129.55.99]:36042 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab3LMImP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:42:15 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] ARM: S3C24XX: Fix configuration of gpio port sizes on S3C24XX.
Date: Fri, 13 Dec 2013 09:42:03 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: =?iso-8859-1?q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-samsung-soc" <linux-samsung-soc@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1378889173-7437-1-git-send-email-jose.goncalves@inov.pt> <52AA6909.8050200@inov.pt> <CACRpkdbBqqbkp3ap3Y=C5zC3Cq9jd+dL4iPZ9-2-Fd81GLAPBA@mail.gmail.com>
In-Reply-To: <CACRpkdbBqqbkp3ap3Y=C5zC3Cq9jd+dL4iPZ9-2-Fd81GLAPBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201312130942.03674.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 13. Dezember 2013, 09:12:52 schrieb Linus Walleij:
> On Fri, Dec 13, 2013 at 2:55 AM, José Miguel Gonçalves
> 
> <jose.goncalves@inov.pt> wrote:
> > On 27-09-2013 15:17, Linus Walleij wrote:
> >> On Wed, Sep 11, 2013 at 10:46 AM, José Miguel Gonçalves
> >> 
> >> <jose.goncalves@inov.pt> wrote:
> >>> Some GPIO line limits are incorrectly set which, for instance,
> >>> does not allow nRTS1 (GPH11) configuration on a S3C2416 chip.
> >>> 
> >>> Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>
> >>> ---
> >>> 
> >>>   arch/arm/mach-s3c24xx/include/mach/gpio.h |   10 +++++-----
> 
> (...)
> 
> > Was this patch forgotten?
> 
> Not by me, I just never got an ACK from the Samsung maintainers,
> so I can't apply it to the GPIO tree.
> 
> Ben, Kukjin: can one of you ACK this so I can take it through the
> GPIO tree?

again not the maintainer :-), but I've looked through the manuals of s3c24xx 
socs and the new values look correct [I had looked up the patch content in the 
list archive], so

Acked-by: Heiko Stuebner <heiko@sntech.de>


But Jose, you should really really look into moving to devicetree with your 
platform, if you're not already doing so. Pinctrl support is already present, 
and I'm hopefull the move to the common clock framework I posted a few days 
ago might make it too.


Heiko
