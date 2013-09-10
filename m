Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab3IJPbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:31:09 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:43227 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3IJPbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:31:06 -0400
MIME-Version: 1.0
In-Reply-To: <1378825549.2627.316.camel@shinybook.infradead.org>
References: <1378766555-9679-1-git-send-email-khilman@linaro.org>
	<CA+55aFxNbH+G6DVQNxE9di_btA5hxFH93af_vjN2v0eH8e5W-g@mail.gmail.com>
	<1378825549.2627.316.camel@shinybook.infradead.org>
Date: Tue, 10 Sep 2013 08:31:04 -0700
X-Google-Sender-Auth: -IIQviVr-Oj-ul7drNclmimAXTA
Message-ID: <CA+55aFyRUZMJiotV0kAUoeEFpFdvK2r-3rXuS7NO4jHoQ+OkPA@mail.gmail.com>
Subject: Re: [GIT PULL 0/3] ARM: SoC: Second round of changes for v3.12
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Kevin Hilman <khilman@linaro.org>, ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 8:05 AM, David Woodhouse <dwmw2@infradead.org> wrote:
>
> In cost-sensitive products (and what *isn't* cost-sensitive these days),
> you really don't want to have to put an extra EEPROM on the board
> somewhere

Don't be silly. Nobody wants an extra chip. Especially not one that is
programmable separately from the hardware. That way lies madness and
the usual firmware crazies.

It's not even what I asked for. I talked about discoverable buses. How
hard is that to understand? No extra chips, no eeprom, just a bus with
a notion of configuration cycles. It doesn't even have to be as
complicated as PCI, it could easily be a read-only model.

But no, every SoC designer out there seems to want to make their
hardware crap. Don't be surprised when I then call them out on the
fact. And don't bring up totally irrelevant issues that have nothing
to do with anything.

Is there a cost? Yes, it's a cost of good design and effort to try to
get it right. Usually that cost pays itself back over the years.

            Linus
