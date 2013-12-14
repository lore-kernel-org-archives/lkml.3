Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab3LNTe3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 14:34:29 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:48712 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab3LNTe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 14:34:27 -0500
Message-ID: <1387049660.7152.317.camel@host5.omatika.ru>
Subject: Re: [PATCH v2 03/16] ARM: dts: provide DMA config to pxamci
From: Sergei Ianovich <ynvich@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        linux-mmc@vger.kernel.org
Date: Sat, 14 Dec 2013 23:34:20 +0400
In-Reply-To: <201312142006.26979.arnd@arndb.de>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
	 <1386901645-28895-1-git-send-email-ynvich@gmail.com>
	 <1386901645-28895-4-git-send-email-ynvich@gmail.com>
	 <201312142006.26979.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-14 at 20:06 +0100, Arnd Bergmann wrote:
> On Friday 13 December 2013, Sergei Ianovich wrote:
> > Non-dts implementation supply required DMA channel numbers as
> > IORESOURCE_DMA. However, there is was no way to get them from
> > device tree.
> 
> Please update this changeset comment, I think it still refers to
> the earlier version.

---
Non-dts implementation supply required DMA channel numbers as
IORESOURCE_DMA. We can also get them from the device tree, if it
is present.
---

Is this fine?

Should I post v3, if so? 

> > Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
> > CC: Daniel Mack <zonque@gmail.com>
> > CC: Arnd Bergmann <arnd@arndb.de>
> 
> The patch looks ok in case we are merging your patches for 3.14
> and Daniel's patches later than that. If they end up in the
> same merge window however, we'd have to be care to resolve
> the obvious conflict in a proper way.

The most recently published Daniel's patch (Aug 2013) wraps
IORESOURCE_DMA handling on DT presence in a similar way, but doesn't do
any actual DT processing. So there is no conflict at the moment. Daniel
can comment better on this, though.


