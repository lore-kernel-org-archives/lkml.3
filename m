Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab3CVIO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:14:27 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:58293 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab3CVIOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:14:22 -0400
MIME-Version: 1.0
In-Reply-To: <1362139636-23579-1-git-send-email-linus.walleij@stericsson.com>
References: <1362139636-23579-1-git-send-email-linus.walleij@stericsson.com>
Date: Fri, 22 Mar 2013 09:14:21 +0100
Message-ID: <CACRpkdZYrLkxu3q=e8Cxt+3S5MPzevH-1iarUFCBKzqTsxnUuA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: stmpe: DT: Enable no-irq mode configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Anmar Oueja <anmar.oueja@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 1:07 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:

> From: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
>
> If there is no interrupt property into stmpe node
> then activate the no-irq mode by setting the irq
> value to -1.
>
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Hi Sam, ping on this!

Yours,
Linus Walleij
