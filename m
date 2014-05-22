Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaEVWDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 18:03:32 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:50194 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaEVWDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 18:03:31 -0400
MIME-Version: 1.0
In-Reply-To: <537921DE.3030107@gmail.com>
References: <1399267649-20218-1-git-send-email-antoine.tenart@free-electrons.com>
	<CACRpkdYJU3HN2u=eFPUyM4eMmuT1Xw19zxjpb5nj9nXnar3_-A@mail.gmail.com>
	<537921DE.3030107@gmail.com>
Date: Fri, 23 May 2014 00:03:30 +0200
Message-ID: <CACRpkdYEVHRw2fukQD6fn0qYauquEWrzhVTBZvGLFNgzPmSX9g@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] ARM: berlin: add pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 11:10 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> I have reworked berlin's pinctrl drivers so they use a mmio regmap
> instead of ioremapped addresses. Instead of "independent" pinctrl
> nodes, there will be common chip-ctrl/system-ctrl nodes that provide
> both clocks and pinctrl (and reset, padmux, ...).
(...)
> I need Alexandre and Antoine to add the necessary changes for BG2Q
> clocks and pinctrl respectively first, but do you prefer proper
> follow-up patches or can you squash them into the ones you've just
> taken?

I just took the Berlin patches out of my queue. Apparently this
driver needs some more maturing so let's not rush it at this point.
Let us merge this after v3.16-rc1 instead as one of the first things.

Yours,
Linus Walleij
