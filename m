Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab3HWRrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:47:32 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:37406 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab3HWRra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:47:30 -0400
MIME-Version: 1.0
In-Reply-To: <201308200629.r7K6TNUS010648@localhost.localdomain>
References: <201308200629.r7K6TNUS010648@localhost.localdomain>
Date: Fri, 23 Aug 2013 19:47:30 +0200
Message-ID: <CACRpkdbUv+59qZs1m3QUq11aad5RC-V-d1-TZeADjfy==Yu-+w@mail.gmail.com>
Subject: Re: [PATCH] MAX7301 GPIO: Reverting "Do not force SPI speed when
 using OF Platform"
From: Linus Walleij <linus.walleij@linaro.org>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Roland Stigge <stigge@antcom.de>, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 8:29 AM, Christophe Leroy
<christophe.leroy@c-s.fr> wrote:

> This patch reverts commit 047b93a35961f7a6561e6f5dcb040738f822b892 which breaks
> MAX7301 GPIO driver because that commit was dependant on a rejected patch that
> was implementing selection of SPI speed from the Device Tree.
>
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Patch applied with Roland's ACK.

But seriously, this is the kind of stuff that scares me a lot,
when developers merge dependent patches into two different
trees, that is just a recipe for chaos and me getting flamed
by other kernel maintainers.

There is *no* mention of this dependency in the other
commit.

Yours,
Linus Walleij
