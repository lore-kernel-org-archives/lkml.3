Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763666Ab3ECUzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:55:14 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:43783 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3ECUzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:55:12 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-25-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-25-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 22:55:11 +0200
Message-ID: <CACRpkdayY5BH3t-0m9w9SW4Ru47=Vc6N9nV=vKvHTRMDTReLmA@mail.gmail.com>
Subject: Re: [PATCH 24/63] dmaengine: ste_dma40: Allocate plat_data on declaration
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
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

On Fri, May 3, 2013 at 4:32 PM, Lee Jones <lee.jones@linaro.org> wrote:

> It's the way that most other drivers do it.
>
> Very trivial clean-up which reduces line count and simplifies code.
>
> Acked-by: Vinod Koul <vnod.koul@intel.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to my ux500-dma40 branch.

Thanks!
Linus Walleij
