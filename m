Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaAOHbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 02:31:15 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:50897 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaAOHbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 02:31:12 -0500
MIME-Version: 1.0
In-Reply-To: <1389271829-6272-2-git-send-email-tomi.valkeinen@ti.com>
References: <1389271829-6272-1-git-send-email-tomi.valkeinen@ti.com>
	<1389271829-6272-2-git-send-email-tomi.valkeinen@ti.com>
Date: Wed, 15 Jan 2014 08:31:11 +0100
Message-ID: <CACRpkdauOC9gceDn7mqRWZmFZomyAKuXuY8ZwHmpDXnH3iOjJw@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: single: fix pcs_disable with bits_per_mux
From: Linus Walleij <linus.walleij@linaro.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 1:50 PM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:

> pcs_enable() uses vals->mask instead of pcs->fmask when bits_per_mux is
> enabled. However, pcs_disable() always uses pcs->fmask.
>
> Fix pcs_disable() to use vals->mask with bits_per_mux.
>
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Patch applied. However make sure to CC Haojian on such patches as
he's using it on a non-OMAP system and often has good feedback.

Yours,
Linus Walleij
