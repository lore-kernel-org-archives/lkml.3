Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbaIDQ1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:27:16 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:46607 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbaIDQ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:27:12 -0400
MIME-Version: 1.0
In-Reply-To: <1409335127-26712-3-git-send-email-soren.brinkmann@xilinx.com>
References: <1409335127-26712-1-git-send-email-soren.brinkmann@xilinx.com>
	<1409335127-26712-3-git-send-email-soren.brinkmann@xilinx.com>
Date: Thu, 4 Sep 2014 18:27:11 +0200
Message-ID: <CACRpkdbb0oeA0b5SSLtR6U7jv8asCeEJdHEsDAg7_tH+GHc5RQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] gpio: zynq: Fixed broken wakeup implementation
From: Linus Walleij <linus.walleij@linaro.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Ezra Savard <ezras@xilinx.com>,
        Ezra Savard <ezra.savard@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 7:58 PM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> From: Ezra Savard <ezra.savard@xilinx.com>
>
> Use of unmask/mask in set_wake was an incorrect implementation. The new
> implementation correctly sets wakeup for the gpio chip's IRQ so the gpio chip
> will not sleep while wakeup-enabled gpio are in use.
>
> Signed-off-by: Ezra Savard <ezra.savard@xilinx.com>
> Reviewed-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Patch applied.

However the problems seems quite generic.

Do you see this kind of error in other GPIO drivers?

IRQchip semantics always make me nervous.

Yours,
Linus Walleij
