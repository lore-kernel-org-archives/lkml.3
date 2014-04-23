Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaDWKf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:35:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50047 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404AbaDWKfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:35:55 -0400
Date: Wed, 23 Apr 2014 11:35:36 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Rob Herring <robherring2@gmail.com>, Lee Jones <lee.jones@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/3] of: Handle memory@0 node on PPC32 only
Message-ID: <20140423103536.GC30036@e106331-lin.cambridge.arm.com>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
 <1397756521-29387-4-git-send-email-leif.lindholm@linaro.org>
 <CAMuHMdXBNWum7UJ95uT2hwTd1b5C8ebF2LQ4T-A+RS80p7MH=A@mail.gmail.com>
 <20140418125924.GF5904@bivouac.eciton.net>
 <CAL_JsqJTMWKh3gsv0TnRap82+7BM4XaT4ZAWkQmyfvzTqOq12g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJTMWKh3gsv0TnRap82+7BM4XaT4ZAWkQmyfvzTqOq12g@mail.gmail.com>
Thread-Topic: [PATCH 3/3] of: Handle memory@0 node on PPC32 only
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> > index 889005f..230c747 100644
> > --- a/drivers/of/Kconfig
> > +++ b/drivers/of/Kconfig
> > @@ -77,4 +77,7 @@ config OF_RESERVED_MEM
> >         help
> >           Helpers to allow for reservation of memory regions
> >
> > +config OF_MEMORY_AT_0_QUIRK
> > +       def_bool n
> 
> I do not like this because it would not scale to many quirks. As I
> said,, my preference here would be to just add a WARN.

I would very much like to be able to remove the quirk entirely for arm64
if possible, which would require more than the addition of a WARN.

> The other option is get approval to break compatibility on the ST
> platform. It may not be a concern on certain platforms.

Lee, would you be able to provide an answer either way so we can get
the discussion moving?

Cheers,
Mark.
