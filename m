Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3IRRSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:18:05 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:54272 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab3IRRSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:18:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>, George Cherian <george.cherian@ti.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: PCF857x and 16-bit GPIO expanders
Date: Wed, 18 Sep 2013 19:18:04 +0200
Message-ID: <2356541.62QktiIBr5@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CACRpkdYn8yaTyFJMaC3vK4kGrQsaZpAX=pyn5y33ers7QhQ_pg@mail.gmail.com>
References: <20130917190732.GD15645@radagast> <CACRpkdYn8yaTyFJMaC3vK4kGrQsaZpAX=pyn5y33ers7QhQ_pg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 September 2013 13:16:27 Linus Walleij wrote:
> On Tue, Sep 17, 2013 at 9:07 PM, Felipe Balbi <balbi@ti.com> wrote:
> > has anyone ever successfully using gpio-pcf857x.c driver with 16-bit
> > gpio expanders ? We're having some issues here where toggling the last
> > gpio pin (gpio 15) on a PCF8575 device causes platform to hang and I
> > can't come up with any explanation of why would it hang...
> 
> Bouncing the question to George, Laurent and Kuninori...

I've got a board with a PCF8575 chip, but it uses I/Os 8 to 14 only as far as 
I know.

I can try toggling I/O 15, but that will need to wait until next week as I'm 
currently travelling without access to the hardware.

-- 
Regards,

Laurent Pinchart

