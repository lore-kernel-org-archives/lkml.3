Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab3HGTeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:34:18 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:60622 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab3HGTeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:34:17 -0400
MIME-Version: 1.0
In-Reply-To: <000001ce9284$c6bd34b0$54379e10$@samsung.com>
References: <000001ce9284$c6bd34b0$54379e10$@samsung.com>
Date: Wed, 7 Aug 2013 21:34:16 +0200
Message-ID: <CACRpkdbuXmU5n35PE_S0mi7h96zJZ2N9NaUMDBrSJ3HA4uhv=A@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: pinconf: fix comparison of different types
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 11:10 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> Fix the following sparse warning:
>
> drivers/pinctrl/pinconf.c:521:20: error: incompatible types in comparison expression (different type sizes)
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied, thanks!

Yours,
Linus Walleij
