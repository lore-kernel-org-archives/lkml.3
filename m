Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab3E0LjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 07:39:10 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:64850 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab3E0LjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 07:39:08 -0400
MIME-Version: 1.0
In-Reply-To: <1369227995-17142-1-git-send-email-lee.jones@linaro.org>
References: <1369227995-17142-1-git-send-email-lee.jones@linaro.org>
Date: Mon, 27 May 2013 13:39:07 +0200
Message-ID: <CACRpkdYAd=X7rCj+Xs=cQ5CZf3-mpLpiGKjmfVZ+pC_QSq-+Kg@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: regulators: Remove misleading comment
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

On Wed, May 22, 2013 at 3:06 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This patch removes a comment which explains that the ab8505 platform
> uses the same initialisation settings as the ab8500. Well when this
> changed and the ab8505 started using its own set of initialisation
> values, someone forgot to remove it.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied for ux500-core, thanks!

Yours,
Linus Walleij
