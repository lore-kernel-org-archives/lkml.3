Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab3DYLSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:18:00 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:46109 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3DYLR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:17:58 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-21-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-21-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 13:17:58 +0200
Message-ID: <CACRpkdaEK9fkcqY1So9UdUeeyJbenve+XUyk8ra7ZWQPNhobdg@mail.gmail.com>
Subject: Re: [PATCH 20/32] dmaengine: ste_dma40: Move rev error-check up to
 revision acquisition
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

> At the moment we fetch the hardware revision, then do some stuff, then
> check whether the revision is correct and return in error if it's not.
> Well we may as well check it as soon as we know what it is, so let's
> move the check right up underneath where we acquire the version.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
