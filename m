Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab3EMHnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 03:43:50 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64473 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab3EMHnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 03:43:49 -0400
MIME-Version: 1.0
In-Reply-To: <1362042438-13887-1-git-send-email-linus.walleij@stericsson.com>
References: <1362042438-13887-1-git-send-email-linus.walleij@stericsson.com>
Date: Mon, 13 May 2013 09:43:48 +0200
Message-ID: <CACRpkdbdOz79Qd7bEOmdjPQcq8zK6CU94COuN=h8Bp45Q+BkZg@mail.gmail.com>
Subject: Re: [PATCH] irqdomain: document the simple domain first_irq
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anmar Oueja <anmar.oueja@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 10:07 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:

> From: Linus Walleij <linus.walleij@linaro.org>
>
> The first_irq needs to be zero to get a linear domain and that
> comes with special semantics. We want to simplify this going
> forward but some documentation never hurts.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Ping on this, seems to have been missed for ~2 months,
should go cleanly into -rc fixes so I do not need to keep this
patch in my tree...

Yours,
Linus Walleij
