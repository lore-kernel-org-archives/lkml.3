Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbaIXLiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:38:09 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:55940 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaIXLiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:38:06 -0400
MIME-Version: 1.0
In-Reply-To: <1411513125-20712-1-git-send-email-gvormayr@gmail.com>
References: <1411031032-20649-1-git-send-email-gvormayr@gmail.com>
	<1411513125-20712-1-git-send-email-gvormayr@gmail.com>
Date: Wed, 24 Sep 2014 13:38:04 +0200
Message-ID: <CACRpkdYW17RtVEfGia8Lp2RE3WB1_TPone5ZHbY86WQ2RLezYg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] gpio: Fix ngpio in gpio-xilinx driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Gernot Vormayr <gvormayr@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:58 AM, Gernot Vormayr <gvormayr@gmail.com> wrote:

> If one adds gpio-controller; to the chip in the devicetree, then
> initialization fails with 'gpiochip_find_base: cannot find free range',
> because ngpio is 0. This patch fixes the bug.
>
> This version includes the suggestions from Linus Walleij.
>
> Tested on ml507 board.
>
> Signed-off-by: Gernot Vormayr <gvormayr@gmail.com>

Patch applied.

Yours,
Linus Walleij
