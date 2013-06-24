Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3FXPQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:16:11 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:37401 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab3FXPQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:16:07 -0400
MIME-Version: 1.0
In-Reply-To: <1371729758-10196-1-git-send-email-james.hogan@imgtec.com>
References: <1371729758-10196-1-git-send-email-james.hogan@imgtec.com>
Date: Mon, 24 Jun 2013 17:16:06 +0200
Message-ID: <CACRpkdYkDEz8xZyhTSNwLx3MvNRDBG+rtP2599KN9CzsCRtQQg@mail.gmail.com>
Subject: Re: [PATCH 0/7] metag: tz1090: add irq-pdc, pinctrl and gpio to DT
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 2:02 PM, James Hogan <james.hogan@imgtec.com> wrote:

> This patchset, based on and for the metag tree, adds the necessary
> device tree nodes and selects the necessary Kconfig symbols in order to
> enable the irq-imgpdc, {pinctrl,gpio}-tz1090[-pdc] drivers once they are
> accepted and merged.
>
> The first two patches set things up for metag so that we can include
> <dt-bindings/*> files from device tree files.
>
> I plan on applying the first two patches soon, and the others after the
> corresponding drivers have been accepted into the appropriate trees on
> which they depend.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>

The series:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
