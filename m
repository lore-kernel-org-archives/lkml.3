Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaGGKUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:20:00 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:41386 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaGGKT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:19:58 -0400
MIME-Version: 1.0
In-Reply-To: <1402596380-18783-1-git-send-email-eric.ernst@linux.intel.com>
References: <CACRpkdbU-d7Gdji2fJr4h7bC58d63E_CAVeSHZm3ARuut1UFKQ@mail.gmail.com>
	<1402596380-18783-1-git-send-email-eric.ernst@linux.intel.com>
Date: Mon, 7 Jul 2014 12:19:58 +0200
Message-ID: <CACRpkdYBfRf7Ztgd2wW=HfCNTNdOtpe70iVGULrQVcOh0W9J1g@mail.gmail.com>
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

> From: Eric Ernst <eric.ernst@linux.intel.com>
>
> For Baytrail, you should never set a GPIO set to direct_irq
> to output mode.  When direct_irq_en is set for a GPIO, it is
> tied directly to an APIC internally, and making the pad output
> does not make any sense. Assert a WARN() in the event this happens.
>
> Signed-off-by: Eric Ernst <eric.ernst@linux.intel.com>
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Patch applied.

Sorry for the delay.

Yours,
Linus Walleij
