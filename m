Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbaCNQ1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:27:40 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:45088 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbaCNQ1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:27:37 -0400
MIME-Version: 1.0
In-Reply-To: <1394813334-22549-1-git-send-email-delicious.quinoa@gmail.com>
References: <1394813334-22549-1-git-send-email-delicious.quinoa@gmail.com>
Date: Fri, 14 Mar 2014 17:27:37 +0100
Message-ID: <CACRpkdbeDbr+tH4xb_MUNSLCcTYpdHNjkBN5uPjHcSm9sWAQBA@mail.gmail.com>
Subject: Re: [PATCH] gpio: gpio-dwapb size-cells should be two
From: Linus Walleij <linus.walleij@linaro.org>
To: Alan Tull <delicious.quinoa@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.com>, Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Kumar Gala <galak@codeaurora.org>,
        Rob Landley <rob@landley.net>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 5:08 PM, Alan Tull <delicious.quinoa@gmail.com> wrote:

> From: Alan Tull <atull@altera.com>
>
> Fix size-cells to show use of OF_GPIO_ACTIVE_LOW flag.
>
> Signed-off-by: Alan Tull <atull@altera.com>

OK patch applied.

Yours,
Linus Walleij
