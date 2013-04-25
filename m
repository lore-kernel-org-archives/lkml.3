Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab3DYLUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:20:22 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:34127 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab3DYLUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:20:21 -0400
MIME-Version: 1.0
In-Reply-To: <20130424083944.GG17416@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-22-git-send-email-lee.jones@linaro.org>
	<20130424083944.GG17416@gmail.com>
Date: Thu, 25 Apr 2013 13:20:20 +0200
Message-ID: <CACRpkdaANF-ZA2wbfMdFcZ-4M0mAnRoJu_hZ07X75Vg_J5LiPA@mail.gmail.com>
Subject: Re: [PATCH 21/32 v2] dmaengine: ste_dma40: Also report the number of
 logical channels
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

On Wed, Apr 24, 2013 at 10:39 AM, Lee Jones <lee.jones@linaro.org> wrote:

> dmaengine: ste_dma40: Also report the number of logical channels
>
> Now we know the total of physical and logical channels, we may as
> well report them within the information log.
>
> Before:
> dma40 dma40.0: hardware revision: 3 @ 0x801c0000 with 8 physical channels
>
> After:
> <as above ...> and 256 logical channels
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
