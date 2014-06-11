Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaFKI4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:56:47 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:63707 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969AbaFKI4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:56:45 -0400
MIME-Version: 1.0
In-Reply-To: <1402238830.32652.3.camel@phoenix>
References: <1402238742.32652.1.camel@phoenix>
	<1402238830.32652.3.camel@phoenix>
Date: Wed, 11 Jun 2014 10:56:44 +0200
Message-ID: <CACRpkdZ4BVe5VH4rGcZ-S7YazWDK20pMVxqV4KSGoKw7jf-Rmw@mail.gmail.com>
Subject: Re: [PATCH 2/2] regulator: ab8500: Remove ab8500_regulator_debug_init/exit()
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 8, 2014 at 4:47 PM, Axel Lin <axel.lin@ingics.com> wrote:

> CONFIG_REGULATOR_AB8500_DEBUG is always not defined.
> ab8500_regulator_debug_init() is not called at all now,
> ab8500_regulator_debug_exit() simply return 0, thus remove them.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
