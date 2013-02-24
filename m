Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346Ab3BXXPi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 18:15:38 -0500
Received: from gloria.sntech.de ([95.129.55.99]:39359 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214Ab3BXXPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 18:15:36 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: return real error codes when pinctrl is not included
Date: Mon, 25 Feb 2013 00:15:29 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Tomasz Figa <t.figa@samsung.com>, Prathyush K <prathyush@chromium.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org
References: <201302231855.47560.heiko@sntech.de> <201302242334.42408.heiko@sntech.de> <CACRpkdbKFWcT_Oa00nd_Op5ndOEc-cEkZm6fzHRuxs0Rc+ZOeA@mail.gmail.com>
In-Reply-To: <CACRpkdbKFWcT_Oa00nd_Op5ndOEc-cEkZm6fzHRuxs0Rc+ZOeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201302250015.29899.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 24. Februar 2013, 23:42:32 schrieb Linus Walleij:
> On Sun, Feb 24, 2013 at 11:34 PM, Heiko Stübner <heiko@sntech.de> wrote:
> > [Me]
> > 
> >> This make me suspect that you have this ugly patch in some
> >> private repo and I will be seeing it again and again :-(
> > 
> > All my s3c24xx work is done is my spare time, so I have to confess I came
> > up with this "ugly patch" all by myself when working on dt support for
> > my machine and stumbling upon the described problem with the pin
> > configuration.
> > 
> > So, as it is obviously wrong, I also won't hold onto it.
> > 
> > In any case, thanks for the thorough explanation, which I probably won't
> > forget anytime soon.
> 
> Hm, maybe I have come across as too harsh and then I feel bad about
> that :-(
>
> I really want spare-time contributors, they are often more valueable
> in addition to the corporate ones since they provide an outside view
> of things.

Just to ease your mind, it didn't sound to harsh and my mail wasn't meant to 
criticize (hopefully it didn't sound that way) - I am very much grateful for 
the explanation.

Writing a pinctrl driver for the s3c24xx arches is still on my list, so my 
understanding of pinctrl (above knowing of its existence) is not very broad 
yet. With your explanation, in retrospect I can understand the ugliness of the 
patch now :-) as it goes against a core principle.


Heiko
