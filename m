Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab3E0G44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 02:56:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56771 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499Ab3E0G4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 02:56:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Tang <dt.tangr@gmail.com>
Subject: Re: [RFC PATCHv4 1/6] arm: TI-Nspire platform code
Date: Mon, 27 May 2013 08:56:19 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com> <201305262246.12803.arnd@arndb.de> <3ED6FFF2-89E2-4426-8DDC-10B4E6C79F26@gmail.com>
In-Reply-To: <3ED6FFF2-89E2-4426-8DDC-10B4E6C79F26@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305270856.19456.arnd@arndb.de>
X-Provags-ID: V02:K0:C543HM5Pi6/xNhE9zHUNlgvg2cR0KCozv3l6pfZ9aAO
 UvZQvK9ynidQkUF+uD0rJIr13XDsS2JzXi6h6Iymi5wh0hNEqW
 gPEpSoPFF0O+v3fmaC0yb+B/RNIA4a0n2opmGAvfk4pCkSpUeL
 1I9zjjkQMcDexslsvIx/k5jsGwuTiY/nnUmj+eDNRrRcrJLGN/
 pDfWE2LrOPjq3MdoTouiGsDnSc3eGjUZpbJW4iG6JAUFB7v0eY
 G5EDyo3BvB/KxnnzyIMe2SbZT2xi6P9Tcaqrpn9W4tsMC8igpF
 wNP3nFjQ/JB9TcgHuW5uUszBz0P8xs80vSuYh6Il10e5tKB7sm
 +iOS/5U5a5MZXQWEaJpI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 May 2013, Daniel Tang wrote:
> 
> On 27/05/2013, at 6:46 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > 
> > 
> >> +    {
> >> +            .virtual        =  NSPIRE_PWR_VIRT_BASE,
> >> +            .pfn            = __phys_to_pfn(NSPIRE_PWR_PHYS_BASE),
> >> +            .length         = SZ_4K,
> >> +            .type           = MT_DEVICE
> >> +    }
> >> +};
> > 
> > And I think this one can be replaced with a call to of_iomap:
> 
> Does of_iomap work that early in the boot process?

Not from map_io, but soon after. What is the fist place you
really need it?

	Arnd
