Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab3DYLRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:17:05 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:37321 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137Ab3DYLRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:17:01 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-20-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-20-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 13:17:00 +0200
Message-ID: <CACRpkdZKib-pm3QcJ6e4MnPfjvBp1kJUB3QXeb2ie=kUhshdew@mail.gmail.com>
Subject: Re: [PATCH 19/32] dmaengine: ste_dma40: Move more setup into the
 configuration routines
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

> The less configuration we can do during the allocation of a channel the
> better. As this will mean the likelihood of requiring extra information
> which isn't normally passed through the dma_request_channel() is lessened.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

NAK. You're breaking memcpy.

Yours,
Linus Walleij
