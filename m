Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab3FJNGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:06:43 -0400
Received: from gloria.sntech.de ([95.129.55.99]:53534 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab3FJNGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:06:42 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 0/2] pinctrl: common handling of generic pinconfig props in dt
Date: Mon, 10 Jun 2013 15:06:35 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201306090159.05383.heiko@sntech.de> <CACRpkdaV0ipY4mYHt998D=NNKrpDaFhCA949V0-93NkOKcvHyA@mail.gmail.com>
In-Reply-To: <CACRpkdaV0ipY4mYHt998D=NNKrpDaFhCA949V0-93NkOKcvHyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201306101506.36098.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 10. Juni 2013, 14:52:13 schrieb Linus Walleij:
> On Sun, Jun 9, 2013 at 1:59 AM, Heiko Stübner <heiko@sntech.de> wrote:
> > following your suggestions for a common handling of things like pulls in
> > dt, I've come up with the following solution - hopefully I've gotten the
> > correct meaning of your explanaitions.
> > 
> > It handles all the pinconfigs that either ignore the argument, or have
> > very simple one, like PIN_CONFIG_OUTPUT does.
> 
> OK patches applied. It needs some rough fixes like NULL check
> on kmalloc() but it'll do for a starter.

gah, sorry ... I have urge to crawl under a rock now for forgetting something 
this obvious ;-) .

Apart from the NULL check what more did I mess up? Should I send a fixup patch 
or do you want to do it?


> Now I can tell everyone to
> use this and refer to it.
> 
> > I've also attached my current rockchip pinctrl driver to show how it is
> > using this currently.
> 
> OK I might just merge it. If you take the rest of the patches through
> ARM SoC they will need to pull in my tree anyway if it's intended to
> go in this merge window.

go ahead if you like - this is the most current version of the driver and 
would be one patch less to worry about. It would after all come together 
during the merge window again.

And very basic boot of the SoC works even without the pinctrl driver, as the 
uart pins are of course set up by the bootloader.


Thanks
Heiko
