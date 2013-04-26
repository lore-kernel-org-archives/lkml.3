Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab3DZPEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:04:25 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:36087 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3DZPEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:04:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130426113947.GB31899@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-4-git-send-email-lee.jones@linaro.org>
	<20130426113947.GB31899@gmail.com>
Date: Fri, 26 Apr 2013 17:04:23 +0200
Message-ID: <CACRpkdbK+GKMEekKk_bh5oK7NJHMMyQNbgac-D3RKYrg-unwQQ@mail.gmail.com>
Subject: Re: [PATCH 03/32 v4] dmaengine: ste_dma40: Use the BIT macro to
 replace ugly '(1 << x)'s
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

On Fri, Apr 26, 2013 at 1:39 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The aim is to make the code that little more readable.
>
> Acked-by: Vinod Koul <vnod.koul@intel.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Fine with me:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
