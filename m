Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab3FDIys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:54:48 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:60477 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab3FDIyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:54:45 -0400
MIME-Version: 1.0
In-Reply-To: <1369902675-5170-1-git-send-email-lee.jones@linaro.org>
References: <1369902675-5170-1-git-send-email-lee.jones@linaro.org>
Date: Tue, 4 Jun 2013 10:54:44 +0200
Message-ID: <CACRpkdaJMkkwicCNfQpG=w0AOnmEeSLTJF4-C+ZV1v=8MKvsQA@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Reduce PRCMU reg-names to shorter form for
 u8540 DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 10:31 AM, Lee Jones <lee.jones@linaro.org> wrote:

> After some discussion and deliberation we have decided to only use the
> short form of the PRCMU register names i.e. not mention the peripheral
> in which the registers reside.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied.

Yours,
Linus Walleij
