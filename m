Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab3DYLMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:12:48 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:63632 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3DYLMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:12:47 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-18-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-18-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 13:12:47 +0200
Message-ID: <CACRpkdYuV+ZP8nW=PHgiw6KOjM9js9Mwd3-XVXCkH6wq213D0A@mail.gmail.com>
Subject: Re: [PATCH 17/32] dmaengine: ste_dma40: Remove redundant argument
 from d40_phy_cfg()
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:

> d40_phy_cfg is now only ever called to configure physical channels, so
> there's no requirement to pass though an argument describing the type
> of channel and to subsequently test for it.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

As mentioned, squash this into the patch where this is made redundant,
no point in first making an argument unused in one patch and then
deleting it in another patch.

Yours,
Linus Walleij
