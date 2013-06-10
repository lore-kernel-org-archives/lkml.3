Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab3FJKek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:34:40 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:59521 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab3FJKej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:34:39 -0400
Date: Mon, 10 Jun 2013 12:34:35 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, kevin@allwinnertech.com
Subject: Re: [PATCH 4/6] ARM: sunxi: dt: Add Allwinner A10s DTSI
Message-ID: <20130610103435.GJ2748@lukather>
References: <1370795767-9769-1-git-send-email-maxime.ripard@free-electrons.com>
 <1370795767-9769-5-git-send-email-maxime.ripard@free-electrons.com>
 <3346364.JR9UrJYqP8@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3346364.JR9UrJYqP8@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Sun, Jun 09, 2013 at 11:36:24PM +0200, Arnd Bergmann wrote:
> On Sunday 09 June 2013 18:36:05 Maxime Ripard wrote:
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  arch/arm/boot/dts/sun5i-a10s.dtsi | 286 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 286 insertions(+)
> >  create mode 100644 arch/arm/boot/dts/sun5i-a10s.dtsi
> 
> Would it make sense to split out the parts that are common with A13 into
> a separate sun5i.dtsi file?

I don't have the documentation at the moment, so I'm not exactly sure at
which extent it's similar to the A13. Yet for the moment, the two dtsi
are very different (different clock definitions, different muxings,
etc.), so , I'm not quite sure about wether it would make stuff smaller.

Of course, if we find they actually share a lot, we can definitely make
a common sun5i DTSI later.

But if you prefer to have it right now, I can always send a v2 :)

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
