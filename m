Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab3H2Xuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:50:46 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:57467 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3H2Xuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:50:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>, Tomasz Figa <t.figa@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Archit Taneja <archit@ti.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v5] gpio: pcf857x: Add OF support
Date: Fri, 30 Aug 2013 01:52:08 +0200
Message-ID: <1992930.Xjyakli5Kt@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <35333449.0R3QP6op66@avalon>
References: <1377590559-14279-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CACRpkda=pZ6xQ2XJke=MBLiH_DAS8CXW+JOZ856ohGZi+fOCzA@mail.gmail.com> <35333449.0R3QP6op66@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 August 2013 01:44:50 Laurent Pinchart wrote:
> On Thursday 29 August 2013 20:24:32 Linus Walleij wrote:
> > On Wed, Aug 28, 2013 at 1:58 PM, Laurent Pinchart wrote:
> > > On Tuesday 27 August 2013 19:18:55 Wolfram Sang wrote:
> > >> > The driver should support the same chip models reardless of whether
> > >> > it's used with or without DT. If an entry in the OF table has no
> > >> > corresponding entry in the I2C table I would consider that as a
> > >> > driver
> > >> > bug.
> > >> 
> > >> Linus Walleij posted a patch to support DT only probing, but too many
> > >> side-effects showed up. Some were fixable (probe regressions) and some
> > >> need more work, if feasible at all. Most prominent is that runtime
> > >> instantiation of i2c slaves currently needs an entry in the i2c table.
> > > 
> > > Linus, I'd like to get this in v3.12 if it's not too late. Could you
> > > please provide your input ?
> > 
> > Provided some input on the v4 version,
> 
> Do you mean v4 of this patch ? I can't find your reply.

Scratch that, I've found it. Sorry for the noise.

> > due to being a bit overloaded my patch queue is overloaded...
> 
> No worries. We can delay this one until v3.13.
-- 
Regards,

Laurent Pinchart

