Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3ILJeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 05:34:36 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:47565 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3ILJee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 05:34:34 -0400
MIME-Version: 1.0
In-Reply-To: <1378109699-25245-2-git-send-email-sachin.kamat@linaro.org>
References: <1378109699-25245-1-git-send-email-sachin.kamat@linaro.org>
	<1378109699-25245-2-git-send-email-sachin.kamat@linaro.org>
Date: Thu, 12 Sep 2013 11:34:34 +0200
Message-ID: <CACRpkdZW-GJeQnm9btn+WzNP9ZqqjRAyxBriJoL4E7OjztA4LA@mail.gmail.com>
Subject: Re: [PATCH 2/2] dma: ste_dma40: Fix potential null pointer dereference
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 2, 2013 at 10:14 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> kcalloc can return NULL. Check the pointer before dereferencing.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I guess Vinod can take this into fixes for v3.12?

Yours,
Linus Walleij
