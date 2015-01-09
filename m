Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbbAIJci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:32:38 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:54155 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340AbbAIJcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:32:33 -0500
MIME-Version: 1.0
In-Reply-To: <1420481779-22841-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1420481779-22841-1-git-send-email-soren.brinkmann@xilinx.com>
Date: Fri, 9 Jan 2015 10:32:32 +0100
Message-ID: <CACRpkda5mAtves=PZibd6jdVP1ztM0EYA+cnw7Gs+mSVXTkqpw@mail.gmail.com>
Subject: Re: [PATCH RESEND v3] gpio: lib-sysfs: Add 'wakeup' attribute
From: Linus Walleij <linus.walleij@linaro.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Alexandre Courbot <gnurou@gmail.com>, linux-api@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 7:16 PM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> Add an attribute 'wakeup' to the GPIO sysfs interface which allows
> marking/unmarking a GPIO as wake IRQ.
> The file 'wakeup' is created in each exported GPIOs directory, if an IRQ
> is associated with that GPIO and the irqchip implements set_wake().
> Writing 'enabled' to that file will enable wake for that GPIO, while
> writing 'disabled' will disable wake.
> Reading that file will return either 'disabled' or 'enabled' depening on
> the currently set flag for the GPIO's IRQ.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> v3:
>  - add documentation
> v2:
>  - fix error path to unlock mutex before return

Finally applied for v3.20.

Sorry for being a bit conservative and picky at times...

Yours,
Linus Walleij
