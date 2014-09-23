Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbaIWWsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:48:39 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:61282 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbaIWWsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:48:37 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZJajGr+Y4OTBf0W697G9ipBKH-y67EU69C-6cCiVbSRw@mail.gmail.com>
References: <1411031032-20649-1-git-send-email-gvormayr@gmail.com>
	<CACRpkdZJajGr+Y4OTBf0W697G9ipBKH-y67EU69C-6cCiVbSRw@mail.gmail.com>
Date: Wed, 24 Sep 2014 00:48:36 +0200
Message-ID: <CAN+KFvYH_QcaUD5sgqYQTrTtWz7Sh+vV=f=X2D1NFgDBLHqgjA@mail.gmail.com>
Subject: Re: [PATCH 1/1] gpio: Fix ngpio in gpio-xilinx driver
From: Gernot Vormayr <gvormayr@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 5:38 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>
> The fact that the same code appears in two places tells us something
> is not quite right. Can you look into consolidating this (in a separate
> patch)?


Well, I already thought about that, but since the second time is for the
second part of a dual gpio, which has different device tree property names,
the only way of consolidating that I can think of right now would be to
create a function that takes the property names. If you think that's ok,
I can try to come up with something.

Cheers,
Gernot Vormayr
