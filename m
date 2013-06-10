Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab3FJPM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 11:12:27 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:47492 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3FJPMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 11:12:14 -0400
Date: Mon, 10 Jun 2013 16:12:08 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>, broonie@linaro.org
Subject: Re: [PATCH 00/10] regulator: ab8500-ext: Refactorings
Message-ID: <20130610151208.GK20297@gmail.com>
References: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
 <CACRpkdbygDNdsO=EzigPiBSnMmF-NVnF95HeBBavkry93i+ubQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbygDNdsO=EzigPiBSnMmF-NVnF95HeBBavkry93i+ubQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jun 2013, Linus Walleij wrote:

> On Fri, Jun 7, 2013 at 6:11 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > This patch aims to do the following:
> >
> >  - Separate the AB8500 External Regulator out from the AB8500 core
> >    one for added control and reduced complexity
> >  - Enable the AB8500 External Regulator for Device Tree
> >  - Ensure EXT3 supplies the AUX regulators with voltage
> 
> The series:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Once the changes to MFD+Regulator are in I'm happy to take the
> DT patches onto my ux500-devicetree branch. However I fear
> I'll break something if I do it right now?

You can apply all of the DTS changes, no problem.

The 'ux500: regulator_supply' patch, relies on the 'regulator:
supply_name' one however. Mark has taken two of them, I don't know why
the others were missed/intentionally left.

Mark, was there a reason for this?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
