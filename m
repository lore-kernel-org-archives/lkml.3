Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab3IRLYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 07:24:38 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:33062 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3IRLYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 07:24:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130918131237.b8272e45ec6c4ebf360cb4e5@canb.auug.org.au>
References: <20130918131237.b8272e45ec6c4ebf360cb4e5@canb.auug.org.au>
Date: Wed, 18 Sep 2013 13:24:36 +0200
Message-ID: <CACRpkdY3Ox8fZPph-je5OvL9YFD1O2WVt6Ga-_UoAqokRdRiRA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the gpio tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 5:12 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> After merging the gpio tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/gpio/gpio-pcf857x.c: In function 'pcf857x_irq_domain_map':
> drivers/gpio/gpio-pcf857x.c:206:2: error: implicit declaration of function 'set_irq_flags' [-Werror=implicit-function-declaration]
>   set_irq_flags(virq, IRQF_VALID);
>   ^

How typical to miss this. OK I've submitted a fix and pushed
to my tree.

Yours,
Linus Walleij
