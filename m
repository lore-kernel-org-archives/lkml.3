Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763216Ab3ECLQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 07:16:29 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:52800 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762005Ab3ECLQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 07:16:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130501095243.GD25256@gmail.com>
References: <1367336497-10650-1-git-send-email-lee.jones@linaro.org>
	<20130501095243.GD25256@gmail.com>
Date: Fri, 3 May 2013 13:16:25 +0200
Message-ID: <CACRpkdZtOtnUYvLm7BPA98oMOLAMPHpJ9GLoyMXOKW1nsTDYiQ@mail.gmail.com>
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

On Wed, May 1, 2013 at 11:52 AM, Lee Jones <lee.jones@linaro.org> wrote:

> At this moment in time the memcpy channels which can be used by the D40
> are fixed, as each supported platform in Mainline uses the same ones.
> However, platforms do exist which don't follow this convention, so
> these will need to be tailored. Fortunately, these platforms will be DT
> only, so this change has very little impact on platform data.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Real nice!

But can you split this in two patches: one that changes
drivers/dma/ste_dma40* and one sequel patch that changes
Documentation/* and arch/arm/boot/dts/* so I can merge them
out-of-order?

I am trying this development cycle to split changes to the
device trees and bindings off from the rest of the patches
becaused it caused me a mess last cycle.

Yours,
Linus Walleij
