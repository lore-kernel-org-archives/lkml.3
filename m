Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaBXLut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 06:50:49 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:44217 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaBXLur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 06:50:47 -0500
MIME-Version: 1.0
In-Reply-To: <530B1CF4.2060208@gmail.com>
References: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<CACRpkdZ1JR82m46YV5m=b6e3E3OYcNCka_8EiT2VcSPU=ZVLdQ@mail.gmail.com>
	<530B1CF4.2060208@gmail.com>
Date: Mon, 24 Feb 2014 12:50:46 +0100
Message-ID: <CACRpkdYptvexfwASCA3Y84oSpidGF6n9WLTEL2GtRQL9fLYsUg@mail.gmail.com>
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

On Mon, Feb 24, 2014 at 11:20 AM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> Although, I guess instead of applying them separately, it would have
> been better to pull them from Jason's stable topic branch. But that is
> also up to you and Jason may give valuable hints on how to proceed in
> the future.

Yeah I concluded that I should take a branch pull instead, so I'm
just waiting for an indication of which branch to pull in.

Yours,
Linus Walleij
