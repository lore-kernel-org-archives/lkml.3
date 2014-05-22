Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaEVWPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 18:15:22 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:43965 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaEVWPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 18:15:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140520180159.3a70193c@canb.auug.org.au>
References: <20140520180159.3a70193c@canb.auug.org.au>
Date: Fri, 23 May 2014 00:15:20 +0200
Message-ID: <CACRpkdY9taDGRKj_ivkcYaHu+Jz8LnVDt-QQSntkwrcBuLitHA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the mfd-lj tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Lee Jones <lee.jones@linaro.org>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 10:01 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> drivers/mfd/stmpe.c: In function 'stmpe_irq_init':
> drivers/mfd/stmpe.c:1000:15: error: 'struct stmpe' has no member named 'irq_base'
>    base = stmpe->irq_base;
>                ^
>
> Caused by commit 3ba1d516d5fe ("mfd: stmpe: root out static GPIO and
> IRQ assignments").

Some mishap in merging these patches I think. I don't have that
line in my branch with the latest patches, I'll get the proper
versions to Lee somehow.

> This is exactly the same error and commit I reported against the gpio
> tree on Friday.  Why has it come back?

It is supposed to come through both trees but I took the branch
out of GPIO after the initial troubles, but it seems to remain in
MFD.

Yours,
Linus Walleij
