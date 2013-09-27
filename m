Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab3I0Mme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 08:42:34 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:63070 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab3I0Mma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 08:42:30 -0400
MIME-Version: 1.0
In-Reply-To: <001a01ceb9c6$ebaa9010$c2ffb030$%han@samsung.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
	<001a01ceb9c6$ebaa9010$c2ffb030$%han@samsung.com>
Date: Fri, 27 Sep 2013 14:42:30 +0200
Message-ID: <CACRpkdYob7f5XwUr-Uya1vqtvHps6pD8U23GKPRGy-QeUjG_EQ@mail.gmail.com>
Subject: Re: [PATCH 17/20] regulator: tps6105x: use devm_regulator_register()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 10:12 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> Use devm_regulator_register() to make cleanup paths simpler,
> and remove unnecessary remove().
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
