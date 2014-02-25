Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaBYJg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:36:58 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62426 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaBYJgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:36:55 -0500
MIME-Version: 1.0
In-Reply-To: <20140224181023.GA1010@titan.lakedaemon.net>
References: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20140224181023.GA1010@titan.lakedaemon.net>
Date: Tue, 25 Feb 2014 10:36:54 +0100
Message-ID: <CACRpkdZ+YGTyDj6i8c198MdRtz3GY-YBmVO9LysPCcmT4EC0cg@mail.gmail.com>
Subject: Re: [PATCH 00/10] pinctrl: mvebu: remove hard-coded addresses from
 Dove pinctrl
From: Linus Walleij <linus.walleij@linaro.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 7:10 PM, Jason Cooper <jason@lakedaemon.net> wrote:

> Sebastian, Linus,
>
> I've now created mvebu/pinctrl-dove for this series.  It's based on
> v3.14-rc1, and depends on mvebu/pinctrl (which depends on
> mvebu/pinctrl-3xx).
>
> I've kept this series in a separate branch in case we encounter an
> unforeseen problem with something in here.  Then this branch can be
> dropped, and /pinctrl-3xx and /pinctrl will still make it in.
>
> So, all patches except 3 and 4 are in mvebu/pinctrl-dove.  3 and 4 are
> in mvebu/dt.

OK so what should I be pulling in first now?

Yours,
Linus Walleij
