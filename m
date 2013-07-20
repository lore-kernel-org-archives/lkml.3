Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3GTRHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 13:07:18 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:44263 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab3GTRHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 13:07:16 -0400
MIME-Version: 1.0
In-Reply-To: <1372170465-28450-4-git-send-email-james.hogan@imgtec.com>
References: <1372170465-28450-1-git-send-email-james.hogan@imgtec.com>
	<1372170465-28450-4-git-send-email-james.hogan@imgtec.com>
Date: Sat, 20 Jul 2013 19:07:16 +0200
Message-ID: <CACRpkdbLhjRa-6OFK1++5eTFk5+GP7PuDw6GXmSj-F8MgxG0_w@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] gpio-tz1090: convert to use generic irqchip
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 4:27 PM, James Hogan <james.hogan@imgtec.com> wrote:

> Convert gpio-tz1090 driver to use generic irqchips. This allows the
> irq_ack, irq_mask, and irq_unmask callbacks and associated helper
> functions to be removed. Also switch to using irq_setup_alt_chip() in
> the irq_set_type callback instead of using __irq_set_handler_locked().
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> ---
> This patch depends on the generic irqchip linear irqdomain work in
> tip/irq/core.
>
> Changes in v4:

Patch applied. Confirm that the infrastructure is now upstream
pls, this is applied on top of v3.11-rc1.

Yours,
Linus Walleij
