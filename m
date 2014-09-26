Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaIZHTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:19:22 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:63405 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbaIZHTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:19:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Joachim Eastwood <manabian@gmail.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>, dianders@chromium.org,
        kgene.kim@samsung.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        naushad@samsung.com, Li.Xiubo@freescale.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org,
        thomas.ab@samsung.com, vikas.sajjan@samsung.com, chow.kim@samsung.com,
        Lee Jones <lee.jones@linaro.org>, sunil joshi <joshi@samsung.com>,
        b29396@freescale.com
Subject: Re: [PATCH v5] mfd: syscon: Decouple syscon interface from platform devices
Date: Fri, 26 Sep 2014 09:16:29 +0200
Message-ID: <2553182.6YgvmDLuEA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAGhQ9VxwTS9=biwp0nCKu2bVU2aNe679aKR=HU5rd_Uaw99sUw@mail.gmail.com>
References: <1411360807-7750-1-git-send-email-pankaj.dubey@samsung.com> <000d01cfd946$521304f0$f6390ed0$@samsung.com> <CAGhQ9VxwTS9=biwp0nCKu2bVU2aNe679aKR=HU5rd_Uaw99sUw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:cEZfwn9mimI3wWq42U1L5e4D25edd+8RaB1dAz58Oqc
 7zFNeFVGN+NjyZHFc54xi0lYTl2agqTGPRLnEjwE64Na2V4G2b
 0x01WG/8LrsZZoy0MfYlAIFiWMTbY9rbQUNxgw6PJreuZ8ymFS
 w1nqHEBjBpppsBa6Mvqsef5AOWiCD1pHdvGRr/TnFuMNS0Fqfh
 wdSkBog8oNkFWOAUY/Gfxlo5OnWuIWTx2LAlFSCPgILm+Qthbu
 Ek/5CApqvpFjfAUugd60RHmAhb/yAjkE/rRdhHyUWSwK5fkjka
 iIjWg5ylAv0Xy9JDLlGWF5fGwAxkH1TvA5As0Sfe2KYzWHiZ/c
 GsAvclgv6GQ6ipVWUJog=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 September 2014 07:34:12 Joachim Eastwood wrote:
> I am working on Cortex-M4 no-MMU platform that isn't upstream yet, btw.
> 

Sorry for drifting off-topic, but this is very interesting to me. Can you
say which one you are working on and what your timeline is for submitting
it upstream?

I generally like to know about new platforms early, and sometimes we get
multiple people working on the same one.

	Arnd
