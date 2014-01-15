Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaAOHcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 02:32:25 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:43734 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaAOHcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 02:32:23 -0500
MIME-Version: 1.0
In-Reply-To: <1389271829-6272-3-git-send-email-tomi.valkeinen@ti.com>
References: <1389271829-6272-1-git-send-email-tomi.valkeinen@ti.com>
	<1389271829-6272-3-git-send-email-tomi.valkeinen@ti.com>
Date: Wed, 15 Jan 2014 08:32:22 +0100
Message-ID: <CACRpkdY=9Ebo+02wHPVhLB+1o=7zXJFKR-ieotY=U58Ubz44-Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] pinctrl: single: fix infinite loop caused by bad mask
From: Linus Walleij <linus.walleij@linaro.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 1:50 PM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:

> commit 4e7e8017a80e1 (pinctrl: pinctrl-single:
> enhance to configure multiple pins of different modules) improved
> support for pinctrl-single,bits option, but also caused a regression
> in parsing badly configured mask data.
>
> If the masks in DT data are not quite right,
> pcs_parse_bits_in_pinctrl_entry() can end up in an infinite loop,
> trashing memory at the same time.
>
> Add a check to verify that each loop actually removes bits from the
> 'mask', so that the loop can eventually end.
>
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Patch applied.

Yours,
Linus Walleij
