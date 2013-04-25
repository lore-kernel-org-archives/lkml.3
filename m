Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab3DYLYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:24:41 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:61927 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab3DYLYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:24:40 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-24-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-24-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 13:24:39 +0200
Message-ID: <CACRpkdbq3sz-e_ySUYf6a4PiWL4C=Yk=eNFUicUu03pDhJbPig@mail.gmail.com>
Subject: Re: [PATCH 23/32] dmaengine: ste_dma40: Allow driver to be
 probe()able when DT is enabled
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

On Thu, Apr 18, 2013 at 12:12 PM, Lee Jones <lee.jones@linaro.org> wrote:

> When booting using Device Tree, devices aren't registered in the normal
> way. Instead, they need to be provided with a compatible string which is
> held in an OF Match Table for comparison during start-up. Here we provide
> the compatible string and prepare the driver to not receive a platform
> data pointer.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
