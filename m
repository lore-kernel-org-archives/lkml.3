Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762542Ab3ECNmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 09:42:40 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:49063 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762435Ab3ECNmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 09:42:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130503121135.GK24153@gmail.com>
References: <1367336497-10650-1-git-send-email-lee.jones@linaro.org>
	<20130501095243.GD25256@gmail.com>
	<CACRpkdZtOtnUYvLm7BPA98oMOLAMPHpJ9GLoyMXOKW1nsTDYiQ@mail.gmail.com>
	<20130503115739.GJ24153@gmail.com>
	<CACRpkdb-_pf=9cm_Hy25nzFWKSTKc6OmmG9rhN2T1wR1=2tddg@mail.gmail.com>
	<20130503121135.GK24153@gmail.com>
Date: Fri, 3 May 2013 15:42:38 +0200
Message-ID: <CACRpkdaUO=j2Ugd5MKA2iUKV_VX5KJMw=R6hCpA_MjrCQNB+fA@mail.gmail.com>
Subject: Re: [PATCH 1/5 v2] dmaengine: ste_dma40: Allow memcpy channels to be
 configured from DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 2:11 PM, Lee Jones <lee.jones@linaro.org> wrote:

>> Then just arch/arm/boot/dts/* separately.
>
> I'm confused, that's how it is already:

Hm haha yes :-)

> Are you getting enough sleep? ;)

It's more like I'm getting too many patch series...

Yours,
Linus Walleij
