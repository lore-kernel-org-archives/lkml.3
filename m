Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaIDQWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:22:53 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:52292 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaIDQWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:22:51 -0400
MIME-Version: 1.0
In-Reply-To: <1409335127-26712-2-git-send-email-soren.brinkmann@xilinx.com>
References: <1409335127-26712-1-git-send-email-soren.brinkmann@xilinx.com>
	<1409335127-26712-2-git-send-email-soren.brinkmann@xilinx.com>
Date: Thu, 4 Sep 2014 18:22:50 +0200
Message-ID: <CACRpkdbn9XiBXcTr+znxu9MxLdUT5XpSoTdnPKRcfDJyG5cwuQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpio: zynq: Mask non-wakeup GPIO interrupts on suspend
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
> Added flag to the GPIO chip so that IRQ from non-wakeup GPIO will
> not wake the system.
>
> Signed-off-by: Ezra Savard <ezra.savard@xilinx.com>
> Reviewed-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Patch applied.

Yours,
Linus Walleij
