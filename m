Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3CLN6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:58:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64304 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3CLN6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:58:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [RFC 17/17] unicore32: default GENERIC_GPIO to false
Date: Tue, 12 Mar 2013 13:57:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        "Hans-Christian Egtvedt" <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com> <201303121118.55770.arnd@arndb.de> <CAAVeFuKPaopR_5tSSVS_W+USn=qx2VChcb_B2CZTunWaJzwJ=A@mail.gmail.com>
In-Reply-To: <CAAVeFuKPaopR_5tSSVS_W+USn=qx2VChcb_B2CZTunWaJzwJ=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303121357.38696.arnd@arndb.de>
X-Provags-ID: V02:K0:mWpqXV835/rKLfCac2YAu+ROC3cEpTbqndMvCOIpngq
 x5UJpGfI0XSn9r8XKFJiAW37zpdzumXqhBcSMzchEuZDPZXsWX
 a5fTXpQu5RPdzwYRDmQJ6jpqDRn8Y1/VMAkYelsswSGvn95ifL
 e/MjdYf5pkygZC971/Yb2lGhzywfUOLcGxCat2m68XFdbgZOJH
 YXWclS+wJPRv61XQcfFX3Wlrlr1YwtpMNQx70y2SclC/oOhk5l
 bpJYrLexceUbdwSMjLy7+9Ui2TW2dtW9+5MYSFXw1DbuQQGArF
 VHGudfbs1z/JfBbo6CZ1TrTW5Ow8ooamsQtDGHIc5tGi9BlotU
 T+t/GPVTIA4NmkO3yVhY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 March 2013, Alexandre Courbot wrote:
> I have fixed this for unicore32, but a few other architectures use the
> "def_bool n" syntax consistently across their Kconfig, so for
> consistency reasons it is maybe preferable to leave it that way for
> them.

Ok, fair enough.

	Arnd
