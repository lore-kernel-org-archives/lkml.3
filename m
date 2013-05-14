Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab3ENIpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:45:45 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:62611 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab3ENIpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:45:43 -0400
Date: Tue, 14 May 2013 09:45:37 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 3/9] clk: ux500: Provide device enumeration number suffix
 for SMSC911x
Message-ID: <20130514084537.GD3297@gmail.com>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
 <1368019749-19455-4-git-send-email-lee.jones@linaro.org>
 <CACRpkdaWaEct1My5=gZ7Bbbizqsr3BBNSXiahMn3bS7L-SubLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaWaEct1My5=gZ7Bbbizqsr3BBNSXiahMn3bS7L-SubLg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > First Ethernet device has a ".0" appended onto the device name. It
> > appears that we need this in order to obtain the correct clock.
> >
> > Cc: Ulf Hansson <ulf.hansson@linaro.org>
> > Cc: Mike Turquette <mturquette@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>

> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Post -rc1 poke for Mike.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
