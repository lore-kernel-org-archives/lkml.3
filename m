Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbaAHICh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:02:37 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:62836 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbaAHIC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:02:28 -0500
MIME-Version: 1.0
In-Reply-To: <20140108151459.d4743129d9cae88865774073@canb.auug.org.au>
References: <20140108151459.d4743129d9cae88865774073@canb.auug.org.au>
Date: Wed, 8 Jan 2014 09:02:27 +0100
Message-ID: <CACRpkdaGArKx2WXkxrakFQ4vaJtytsbSW8mpA+FdyJxEROURvg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the gpio tree with the xtensa tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 5:14 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Linus,
>
> Today's linux-next merge of the gpio tree got a conflict in
> arch/xtensa/Kconfig between commit dbacef090841 ("xtensa: add SMP
> support") from the xtensa tree and commit a1a2bdec4772 ("gpio: xtensa:
> depend on HAVE_XTENSA_GPIO32") from the gpio tree.

Looks correct, thanks!

Yours,
Linus Walleij
