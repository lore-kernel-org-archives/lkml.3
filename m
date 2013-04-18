Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968290Ab3DRKzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:55:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49383 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967253Ab3DRKzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:55:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 15/32] dmaengine: ste_dma40: Separate Logical Global Interrupt Mask (GIM) unmasking
Date: Thu, 18 Apr 2013 12:54:57 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <1366279934-30761-16-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1366279934-30761-16-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181254.57776.arnd@arndb.de>
X-Provags-ID: V02:K0:G9963k7Qitpu/wkwp8hTpZzslJvXxeyvFSkuURQSOhh
 L8mHt+333LHw6PwJTY7SxooLrOCcfxz6Sdv7rNDarzJBhES1xk
 z/yaMuX89gZ7FprlNEW7k/olxN6pMNW7HIKZZthmEzk9VNtFre
 gNlGZSWPyCxWoAVFAg8N7Dp3wla1uhNPThX9OaUWqhWt128wu+
 9sYpDAdlrxfDK5Yv31Y/OCOS1YwpSgMvwHe9hRjYH+BVqn8cYM
 zM6xRvKU7qCVACXI4zlrNem5Ej7GaMolse2AkLit/K/Uu16tAT
 tdw1w7ABtgLpF0gTorfWyrRfHkvzluVEu6uvVwp7vmzpTCIb8N
 ++SRmCZo+1/j9qjwLpBo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Lee Jones wrote:
> During the initial setup of a logical channel, it is necessary to unmask
> the GIM in order to receive generated terminal count and error interrupts.
> We're separating out this required code so it will be possible to move
> the remaining code in d40_phy_cfg(), which is mostly runtime configuration
> into the runtime_config() routine.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
