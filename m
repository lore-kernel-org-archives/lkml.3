Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737AbaFLHt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:49:28 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:46426 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbaFLHt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:49:27 -0400
MIME-Version: 1.0
In-Reply-To: <1401834316-199359-1-git-send-email-eric.ernst@linux.intel.com>
References: <20140603110600.GG1730@lahna.fi.intel.com>
	<1401834316-199359-1-git-send-email-eric.ernst@linux.intel.com>
Date: Thu, 12 Jun 2014 09:49:27 +0200
Message-ID: <CACRpkdbU-d7Gdji2fJr4h7bC58d63E_CAVeSHZm3ARuut1UFKQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] pinctrl: baytrail: Warn if direct IRQ GPIO set to output
From: Linus Walleij <linus.walleij@linaro.org>
To: eric.ernst@linux.intel.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Gross <mark.gross@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 12:25 AM,  <eric.ernst@linux.intel.com> wrote:

> From: Eric Ernst <eric.ernst@linux.intel.com>
>
> For Baytrail, you should never set a GPIO set to direct_irq
> to output mode.  When direct_irq_en is set for a GPIO, it is
> tied directly to an APIC internally, and making the pad output
> does not make any sense. Assert a WARN() in the event this happens.
>
> Signed-off-by: Eric Ernst <eric.ernst@linux.intel.com>

This does not apply to my devel branch or Torvald's HEAD.
Please rebase and repost, and include Mika's ACK.

Yours,
Linus Walleij
