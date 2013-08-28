Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab3H1TWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:22:42 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:45275 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab3H1TWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:22:41 -0400
MIME-Version: 1.0
In-Reply-To: <1377609561-22054-1-git-send-email-b.brezillon@overkiz.com>
References: <1377609561-22054-1-git-send-email-b.brezillon@overkiz.com>
Date: Wed, 28 Aug 2013 21:22:40 +0200
Message-ID: <CACRpkdYJHctvmK0Lj+dStacCrBZbsVKJFBCc6ZTKWP5SMVVZAw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: at91: fix get_pullup/down function return
From: Linus Walleij <linus.walleij@linaro.org>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 3:19 PM, Boris BREZILLON
<b.brezillon@overkiz.com> wrote:

> In PIO_PUSR and PIO_PPDSR register if a given bit is set 1 this means the
> pullup/down for this pin (pin is represented as a bit position) is
> disabled.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Patch applied, tagged for stable.

Yours,
Linus Walleij
