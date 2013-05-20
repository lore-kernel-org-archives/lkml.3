Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab3ETMge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 08:36:34 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:42385 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255Ab3ETMgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 08:36:32 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-10-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-10-git-send-email-lee.jones@linaro.org>
Date: Mon, 20 May 2013 14:36:31 +0200
Message-ID: <CACRpkdZO4d4jj3EEAAN-QLWj70ivc69rSqXpVwt+R68VGmxBAg@mail.gmail.com>
Subject: Re: [PATCH 09/63] dmaengine: ste_dma40: Rectify incorrect
 configuration validation checking
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 4:31 PM, Lee Jones <lee.jones@linaro.org> wrote:

> If we compare an event's group (dev_type / 16) with STEDMA40_DEV_DST_MEMORY
> (-1), the only way we'd obtain a positive result is if we passed -16 as a
> device type, which is unfeasible. Instead, it would be much more sane to
> compare STEDMA40_DEV_DST_MEMORY against the raw dev_type in order to expect
> the expected result.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Still waiting for Vinod's ACK on this as well.

Vinod?

Yours,
Linus Walleij
