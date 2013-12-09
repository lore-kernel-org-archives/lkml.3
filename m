Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858Ab3LIIdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:33:23 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:65257 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab3LIIdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:33:19 -0500
MIME-Version: 1.0
In-Reply-To: <000f01cef252$8dbe1d90$a93a58b0$%han@samsung.com>
References: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
	<000f01cef252$8dbe1d90$a93a58b0$%han@samsung.com>
Date: Mon, 9 Dec 2013 09:33:19 +0100
Message-ID: <CACRpkdZUsmA=8DW84s=w8NDUBaVdjXWrHYsaNCVnRyg_eUSZ_Q@mail.gmail.com>
Subject: Re: [PATCH 6/6] regulator: stw481x-vmmc: use devm_regulator_register()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 6, 2013 at 8:12 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> Use devm_regulator_register() to make cleanup paths simpler,
> and remove unnecessary remove().
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
