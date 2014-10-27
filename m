Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaJ0Qnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:43:50 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44321 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbaJ0Qnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:43:47 -0400
MIME-Version: 1.0
In-Reply-To: <1413042040-28222-4-git-send-email-vinod.koul@intel.com>
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
	<1413042040-28222-4-git-send-email-vinod.koul@intel.com>
Date: Mon, 27 Oct 2014 17:43:46 +0100
Message-ID: <CACRpkdZegs9zpM0Mxjiqkoc0kJPyz5mvN31x=Pge=TEWqk+U2g@mail.gmail.com>
Subject: Re: [PATCH 04/12] mtd: fsmc_nand: use dmaengine_terminate_all() API
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, Mark Brown <broonie@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 5:40 PM, Vinod Koul <vinod.koul@intel.com> wrote:

> The drivers should use dmaengine_terminate_all() API instead of
> accessing the device_control which will be deprecated soon
>
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
