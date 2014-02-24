Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbaBXKRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:17:08 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:52002 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbaBXKRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:17:03 -0500
MIME-Version: 1.0
In-Reply-To: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 24 Feb 2014 11:17:02 +0100
Message-ID: <CACRpkdZ1JR82m46YV5m=b6e3E3OYcNCka_8EiT2VcSPU=ZVLdQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] pinctrl: mvebu: remove hard-coded addresses from
 Dove pinctrl
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 9:42 AM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> This is a patches separated from one sent earlier [1] with just the
> removal of any hard-coded reg addresses from Dove pinctrl stub.

OK let's queue this a while later on top of the other stuff (that I'm working
on applying right now).

> In the meantime, support for new Armada 375/38x was added that also
> contain patches for pinctrl [2].

I applied these first. Please look at the result once I push out the
pinctrl tree with the 375/38x + your v4 series in combination
(let's see how big mess it will be...)

I'm sorry for not applying the nice patches earlier, forcing you to work
on many parallel series like this, hopefully I'll be able to attend to
them this week.

Yours,
Linus Walleij
