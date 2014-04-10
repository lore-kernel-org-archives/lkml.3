Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbaDJRfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:35:17 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:53035 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbaDJRfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:35:15 -0400
MIME-Version: 1.0
In-Reply-To: <1396865589-9972-2-git-send-email-bigeasy@linutronix.de>
References: <1396865589-9972-1-git-send-email-bigeasy@linutronix.de>
	<1396865589-9972-2-git-send-email-bigeasy@linutronix.de>
Date: Thu, 10 Apr 2014 19:35:14 +0200
Message-ID: <CACRpkdZOJMQV8YLyJ7za08MnyyuSX3RwJ77P+J0bC7qFQPar3w@mail.gmail.com>
Subject: Re: [PATCH 1/5] gpio: dwapb: drop irq_setup_generic_chip()
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jamie Iles <jamie@jamieiles.com>, Alan Tull <atull@altera.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2014 at 12:13 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:

> The driver calls irq_alloc_domain_generic_chips() which creates a gc and
> adds it to gc_list. The driver later then calls irq_setup_generic_chip()
> which also initializes the gc and adds it to the gc_list() and this
> corrupts the list. Enable LIST_DEBUG and you see the kernel complain.
> This isn't required, irq_alloc_domain_generic_chips() did the init.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Patch applied, adding Alan Tull's Tested-by.

Yours,
Linus Walleij
