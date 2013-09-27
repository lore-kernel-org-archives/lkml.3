Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab3I0Mlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 08:41:45 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:46395 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab3I0Mln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 08:41:43 -0400
MIME-Version: 1.0
In-Reply-To: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Date: Fri, 27 Sep 2013 14:41:42 +0200
Message-ID: <CACRpkdZQ+_JY+U+rVCre5i8swciq5X4XQyTKPcgMUYSSefFqVQ@mail.gmail.com>
Subject: Re: [PATCH 01/20] regulator: ab3100: use devm_regulator_register()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 9:48 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> Use devm_regulator_register() to make cleanup paths simpler.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
