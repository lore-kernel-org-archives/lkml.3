Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab3LLQD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:03:59 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:51268 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3LLQD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:03:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] pinctrl: at91: implement at91_pinconf_dbg_show
Date: Thu, 12 Dec 2013 17:04:09 +0100
Message-ID: <6277163.cTcj4OY5rk@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52A9DB3C.7070107@free-electrons.com>
References: <1386421734-10240-1-git-send-email-alexandre.belloni@free-electrons.com> <CACRpkdbAmPxVdQ_hVQSQpgVu324Jg9D6FYj-OyfsorPP2zzdLw@mail.gmail.com> <52A9DB3C.7070107@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 December 2013 16:50:20 Alexandre Belloni wrote:
> On 12/12/2013 15:45, Linus Walleij wrote:
> > On Sat, Dec 7, 2013 at 2:08 PM, Alexandre Belloni
> > 
> > <alexandre.belloni@free-electrons.com> wrote:
> >> This allows to get the pin configuration by using debugfs. On my system:
> >>  # cat /sys/kernel/debug/pinctrl/pinctrl.3/pinconf-pins
> >> 
> >> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > 
> > This is a more invasive patch so I prefer if Laurent ACK this before
> > I apply it.
> 
> Hum, just to be clear, this is an Atmel chip and the Atmel maintainers
> were already in copy. I believe Laurent already has a lot on his plate
> with CDF ;)

Not to mention the rest. I'd love to help with at91 pinctrl, but I think I 
have to draw the line somewhere. I hope it won't come as a shock that I can't 
review the whole kernel :-D

-- 
Regards,

Laurent Pinchart

