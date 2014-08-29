Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaH2FtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 01:49:25 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:45031 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaH2FtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 01:49:24 -0400
MIME-Version: 1.0
In-Reply-To: <1407765115-31662-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1407765115-31662-1-git-send-email-mathias.nyman@linux.intel.com>
Date: Fri, 29 Aug 2014 07:49:23 +0200
Message-ID: <CACRpkdZdBugQ7hfEjg1=wamAZKNJxwbcXz8L7r_hGC2qxSJ8_g@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: baytrail: resolve unbalanced IRQ wake disable warning
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 3:51 PM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:

> Add the IRQCHIP_SKIP_SET_WAKE flag to baytrail gpio irq_chip
> to resolve unbalaced IRQ wake disable warnings.
>
> Suggested-by: Borun Fu <borun.fu@intel.com>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

Patch applied for fixes with Mika's ACK.
Had to rebase it a bit,

Yours,
Linus Walleij
