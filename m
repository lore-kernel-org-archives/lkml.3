Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbaJ2IaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:30:11 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:49134 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbaJ2IaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:30:08 -0400
MIME-Version: 1.0
In-Reply-To: <1414522686-5755-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1414522686-5755-1-git-send-email-alexandre.belloni@free-electrons.com>
Date: Wed, 29 Oct 2014 09:30:07 +0100
Message-ID: <CACRpkdZ2+-H1DYD8zQeLZK3MAtQkhcOzm6zxt_JO4Uq2Sjza5g@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: at91: fix compilation
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 7:58 PM, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:

> Add macros introduced by 4334ac2db2be9e278c95fd15260c1f49f698ffc5 that
> were missed when copying the header.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

I squashed this into the offending commit.

Yours,
Linus Walleij
