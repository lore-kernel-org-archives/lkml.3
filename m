Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934254Ab3ECT6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 15:58:18 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34560 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038Ab3ECT6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 15:58:17 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-10-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-10-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 21:58:16 +0200
Message-ID: <CACRpkdYY7Z2invp-Eq2+n+hqdqxKx05QuKCqAe+PudU9JWGXrg@mail.gmail.com>
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

I'd like Vinod's ACK on this before I send it to ARM SoC but tentatively
applied (and just what I wanted!)

Vinod can I have your ACK on this?

Yours,
Linus Walleij
