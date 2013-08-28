Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab3H1L4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:56:52 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:46893 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab3H1L4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:56:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>, Tomasz Figa <t.figa@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, Wolfram Sang <wsa@the-dreams.de>,
        devicetree@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linux-gpio@vger.kernel.org, Archit Taneja <archit@ti.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v5] gpio: pcf857x: Add OF support
Date: Wed, 28 Aug 2013 13:58:13 +0200
Message-ID: <7583101.2yAsZLOucV@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130827171854.GA2988@katana>
References: <1377590559-14279-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <2400176.9Vcd5TUYl9@avalon> <20130827171854.GA2988@katana>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 August 2013 19:18:55 Wolfram Sang wrote:
> > The driver should support the same chip models reardless of whether it's
> > used with or without DT. If an entry in the OF table has no corresponding
> > entry in the I2C table I would consider that as a driver bug.
> 
> Linus Walleij posted a patch to support DT only probing, but too many
> side-effects showed up. Some were fixable (probe regressions) and some
> need more work, if feasible at all. Most prominent is that runtime
> instantiation of i2c slaves currently needs an entry in the i2c table.

Linus, I'd like to get this in v3.12 if it's not too late. Could you please 
provide your input ?

-- 
Regards,

Laurent Pinchart

