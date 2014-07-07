Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaGGVPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 17:15:03 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46388 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaGGVO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 17:14:59 -0400
MIME-Version: 1.0
In-Reply-To: <1402596380-18783-1-git-send-email-eric.ernst@linux.intel.com>
References: <CACRpkdbU-d7Gdji2fJr4h7bC58d63E_CAVeSHZm3ARuut1UFKQ@mail.gmail.com>
	<1402596380-18783-1-git-send-email-eric.ernst@linux.intel.com>
Date: Mon, 7 Jul 2014 23:14:58 +0200
Message-ID: <CACRpkdbBsP-_K4Y2MS17EuzZeho6uYKqRPHPPL0-KDAamsdxvQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] pinctrl: baytrail: Warn if direct IRQ GPIO set to output
From: Linus Walleij <linus.walleij@linaro.org>
To: eric.ernst@linux.intel.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Gross <mark.gross@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 8:06 PM,  <eric.ernst@linux.intel.com> wrote:

> +       WARN(readl(conf_reg) & BYT_DIRECT_IRQ_EN,
> +               "Potential Error: Setting GPIO with direct_irq_en to output");

Hm in the v4 version you somehow managed to drop the definition
of BYT_DIRECT_IRQ_EN...

I patched it back in. Let's hope it compiles now.

Yours,
Linus Walleij
