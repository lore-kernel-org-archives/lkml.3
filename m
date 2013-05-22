Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3EVNUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:20:22 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:62233 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab3EVNUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 09:20:19 -0400
MIME-Version: 1.0
In-Reply-To: <1369228025-17192-1-git-send-email-lee.jones@linaro.org>
References: <1369228025-17192-1-git-send-email-lee.jones@linaro.org>
Date: Wed, 22 May 2013 15:20:19 +0200
Message-ID: <CACRpkda0Oupr56a+Tj7jKCh2vCaD_R0_KVFBe8ZuYQYgVtG2CA@mail.gmail.com>
Subject: Re: [PATCH] regulator: ab8500: Remove external regulator init() clauses
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 3:07 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The driver no longer needs to worry about which platform can and can't
> use external regulators successfully. Instead platform code will hold
> back external regulator initialisation data in the use-cases where the
> driver isn't applicable.
>
> Cc: Mark Brown <broonie@kernel.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
