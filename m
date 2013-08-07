Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab3HGN7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:59:53 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:39646 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab3HGN7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:59:52 -0400
Date: Wed, 7 Aug 2013 14:59:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 01/22] ARM: ux500: Remove '0x's from HREF v60+ DTS file
Message-ID: <20130807135946.GE18668@lee--X1>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <CACRpkdYAaCrRLjRwZVsq0Av0vc5Y4PODQchEwTCcrmYS47G3jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYAaCrRLjRwZVsq0Av0vc5Y4PODQchEwTCcrmYS47G3jw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Aug 2013, Linus Walleij wrote:

> On Mon, Jul 22, 2013 at 12:52 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> None of these patches apply since I applied your other patch series
> that rename all the files ... can you respin the ux500 "0x"-strip patches
> on top of the rename set? My ux500-devicetree branch can be used
> as a baseline.

I can do that. Although, would you prefer that I fixed-up my renaming
patches, then applied the 0x patches on top instead?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
