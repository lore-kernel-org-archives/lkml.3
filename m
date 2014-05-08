Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbaEHNPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:15:20 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:56929 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbaEHNPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:15:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn@kryo.se>, Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH 3/4] of/platform: fix device naming for non-translatable addresses
Date: Thu, 08 May 2014 15:15:07 +0200
Message-ID: <4916948.fjAQXx11x1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_JsqJEW_Xrfi7OiF6caHVup1Y6-8SvyOJawov8o3oiYiFvXQ@mail.gmail.com>
References: <1399499298-8830-1-git-send-email-robherring2@gmail.com> <4314054.Zr5Mecf9vm@wuerfel> <CAL_JsqJEW_Xrfi7OiF6caHVup1Y6-8SvyOJawov8o3oiYiFvXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:aopBaQIscI/Spfg8WZGxle1Msz6GjPLio0AuEZaT1np
 6vnw9pkj0xgKeyELqybtUrxjN6hYQ3GDuOxaD1+kCvyk4kXP3W
 kg3st/Gnlxkc5hOC8xeD5OGP3QbuXAU1v2QAhsrCYoeXDCqU33
 FIbly6Y0W+K2d5hNFqCqfUU/9NIXKMTUpw/D7mrIQZ2AvxiV8W
 sU14GPuEHRoSFqnUAKBZN3rgrLyRXY5yFAd3Rn+BIuMK3OlUg7
 Qbxidh9XYgGghhkk/fsei+rOvCp32IvjkqriT0R5/YWBM6omu4
 X47dO+3e2dwvJ4pRC3lqkTUQ0XyBnkEx3RVoznXeCZuEi5TY8o
 pfYI6gIoLM9VrXCm7G54=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 May 2014 07:55:06 Rob Herring wrote:
> On Thu, May 8, 2014 at 5:41 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 07 May 2014 16:48:17 Rob Herring wrote:
> >> From: Rob Herring <robh@kernel.org>
> >>
> >> Using non-translatable addresses in platform device names is wrong
> >> because they may not be globally unique. Just use the default naming with
> >> a global index if the address cannot be translated instead.
> >>
> >> of_can_translate_address has the same checks as of_translate_address, so
> >> we can remove it here as well.
> >
> > Have you checked that this doesn't break platforms using clkdev lookup
> > based on names with local addresses? It's quite possible that nobody
> > does that, but it would be good to have someone confirm it.
> 
> I had not, but now I have. There don't appear to be any cases of that.

Ok, thanks for checking.

	Arnd
