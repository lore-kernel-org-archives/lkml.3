Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab3FJPfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 11:35:00 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:32792 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3FJPe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 11:34:58 -0400
Date: Mon, 10 Jun 2013 17:34:56 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 4/4] ARM: sunxi: dt: Register the pio node as interrupt
 controller
Message-ID: <20130610153456.GK2748@lukather>
References: <1370685946-3718-1-git-send-email-maxime.ripard@free-electrons.com>
 <1370685946-3718-5-git-send-email-maxime.ripard@free-electrons.com>
 <CACRpkdZfqspUA1BpzMpM727g-s6ckm=PfDkSo8ambUwdW4J8Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZfqspUA1BpzMpM727g-s6ckm=PfDkSo8ambUwdW4J8Sw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Jun 10, 2013 at 03:57:23PM +0200, Linus Walleij wrote:
> On Sat, Jun 8, 2013 at 12:05 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> 
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> I guess this patch needs to go through the ARM SoC tree.
> 
> Tell me if I can carry it in the pinctrl tree (read: there will be no
> conflicts agains changes from elsewhere) and I'll apply it.

I'll carry this patch through my tree.

Thanks!
Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
