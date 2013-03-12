Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab3CLMKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 08:10:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61882 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3CLMKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:10:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [RFC 17/17] unicore32: default GENERIC_GPIO to false
Date: Tue, 12 Mar 2013 12:10:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Ralf Baechle <ralf@linux-mips.org>, Chris Zankel <chris@zankel.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Kumar Gala <galak@kernel.crashing.org>, acourbot@nvidia.com,
        Jonas Bonn <jonas@southpole.se>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Josh Boyer <jwboyer@gmail.com>,
        "Hans-Christian Egtvedt" <egtvedt@samfundet.no>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mundt <lethal@linux-sh.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, Paul Mackerras <paulus@samba.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com> <201303121118.55770.arnd@arndb.de> <CAAVeFuLJ0VvdOkqyNaVCbFHE-x==OYFC_=HEF2YLqaK6mM+rBw@mail.gmail.com>
In-Reply-To: <CAAVeFuLJ0VvdOkqyNaVCbFHE-x==OYFC_=HEF2YLqaK6mM+rBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303121210.29613.arnd@arndb.de>
X-Provags-ID: V02:K0:z12z8rrKtEV3eoIQyU5Tj7DK6uJjeJ9X0QKjUAw3hBs
 ycnozjoIJ1h7SWE97QVe3gybENfn7OILPedzCYD5l999GeJQMC
 NuCK08Z7rNjqMuEly81SDrLr+OfxONUqHeEeE/yjNOGZpoI1G9
 evjggSl8DIVXUHnc1rEouM4AjPxY5rxUE79FjzU/B9Tq0mKGQL
 SzhrEo2cqPwF41Geb85qH/57j3FP7SxUQAMGMt/bdanvLfyiL9
 0HPJuv7GP1uRpe6Q1RX29Vc63j+NnKbNSUgGnbC8kQOdB721Sr
 SRC3Wy4Pjt0VmPwea1VO5vv7XjsIgNbq4N9Q6o0ILk31hn978S
 ZHJ9Y4U4Qow8m72WXrss=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 March 2013, Alexandre Courbot wrote:
> Thanks, I will fix this in the next version.
> 
> Btw, if this (or rather the next iteration) gets merged, may I suggest to
> do it through the GPIO tree instead of having each architecture picking the
> patches of relevance. A considerable number of other patches that depend on
> this will follow and this will ensure they are picked in the right order.

Sounds reasonable, but I would also suggest you prepare a branch that can
get merged into the GPIO, ARM, PowerPC and MIPS trees to avoid merge
conflicts in that case, since these all will have a number of changes
conflicting with yours.

In the end, I would not care which tree it gets merged through, as long
as all have the same version of your patches.

	Arnd
