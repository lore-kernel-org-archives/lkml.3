Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab3HXIAd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 04:00:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63337 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab3HXIAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 04:00:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 21/33] clk: ux500: Add Device Tree support for the PRCC Kernel clock
Date: Sat, 24 Aug 2013 10:00:01 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org> <20130822092130.GB22023@lee--X1> <CACRpkdYLJdmhCqXpQ0s5nbxRoFdZ3bLn+hxAhkoGHYfvugc=7A@mail.gmail.com>
In-Reply-To: <CACRpkdYLJdmhCqXpQ0s5nbxRoFdZ3bLn+hxAhkoGHYfvugc=7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308241000.01649.arnd@arndb.de>
X-Provags-ID: V02:K0:LFoRlp1+6l6iaQSTxWxMkJdBY+cfGU9u84vKN3r6iAO
 fdWI4JAeNUTA7vb0YGndVR6PmVJvdl+r65I2C26U6tShzP1B7y
 m6zXP5pi4e/3TNDWsjA/+kVb5zdOgT8R5sja+5GUux1sX08l+A
 +KR3VAhkKHynyydpKv2Tg2PpMI3rrQQDJV0aKNPuDVn4SFdg6b
 V/t2agnBXP0hjBd+D0EfqO6myjFg8WM3IpbX78Ww5aA2cMqcsa
 UJaybHY7VGtN+XQzfPzmomcu58xvjad6KLvCahFHWm7an70olJ
 hnQdOQLWk/go/pVTa0u+N/C90UpuaQJ/12KH8gCwqFK8uWSkDe
 gZmr8HAapja8Mg6MvtYA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 August 2013, Linus Walleij wrote:
> I think this is perfectly realistic.
> 
> You're not going to duplicate each clk_register_clkdev(),
> which makes it way smaller than the original function,
> and since one of the function will be inside a
> 
> #ifdef CONFIG_OF
> #endif
> 
> After we switch the entire platform to DT-only it will be pretty
> obvious which big chunk of code that needs to go away, it's
> a clean cut.
> 
> (Note: I know the #ifdef CONFIG_OF is not necessary anymore
> since we switched to multiplatform, but I intend that marker for
> humans, not machines.)
> 

You just reminded me that I'm still sitting on this old patch
to add lots of #ifdef CONFIG_ATAGS to ux500 in the places that need
to get cut out. I don't think I'm able to update that patch at
the moment, but I can send you the old version I have if you
are interested.

	Arnd
