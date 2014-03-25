Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaCYUto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:49:44 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:62294 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbaCYUtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:49:41 -0400
MIME-Version: 1.0
In-Reply-To: <1395505004-22650-3-git-send-email-bigeasy@linutronix.de>
References: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>
	<1395505004-22650-3-git-send-email-bigeasy@linutronix.de>
Date: Tue, 25 Mar 2014 21:49:40 +0100
Message-ID: <CACRpkdaD=hZGJA0r5DcJs-hFnnkKCFeQ9JwJZ4kcLq5Sb+=ZqQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] gpio: dwapb: correct gpio-cells in binding document
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alan Tull <atull@altera.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 5:16 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:

> The example uses gpio-cells = 1 while it should be two (it is even
> mentioned in the text above).
>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

This is obviously correct so patch applied.

How come I cannot see patch 1/7 in my mailbox :-(

I see patches 2-7/7...

Something on my end?

Yours,
Linus Walleij
