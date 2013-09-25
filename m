Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab3IYEv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 00:51:56 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:45828 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab3IYEvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 00:51:55 -0400
Date: Wed, 25 Sep 2013 13:51:53 +0900
From: Simon Horman <horms@verge.net.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: sh-pfc: r8a7790: add pin definitions for
 the I2C3 interface
Message-ID: <20130925045152.GD24243@verge.net.au>
References: <1378742636-11215-1-git-send-email-g.liakhovetski@gmx.de>
 <1378742636-11215-2-git-send-email-g.liakhovetski@gmx.de>
 <CACRpkdbDa5Smpfyneq-SAPYvbxB-ju7-X8kkZ7RFpNcYrcBggg@mail.gmail.com>
 <Pine.LNX.4.64.1309171907220.25596@axis700.grange>
 <CACRpkdYMGiYzLisWfx_wQtw3Gvi3==0D5o7=BG3jcjH-0ea8gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYMGiYzLisWfx_wQtw3Gvi3==0D5o7=BG3jcjH-0ea8gA@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 10:50:07AM +0200, Linus Walleij wrote:
> On Tue, Sep 17, 2013 at 7:10 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > On Tue, 17 Sep 2013, Linus Walleij wrote:
> 
> >> > +/* R8A7790 has 6 banks with 32 GPIOs in each = 192 GPIOs */
> >> > +#define ROW_GROUP_A(r) ('Z' - 'A' + 1 + (r))
> >> > +#define PIN_NUMBER(r, c) (((r) - 'A') * 16 + (c) + 200)
> >> > +#define PIN_A_NUMBER(r, c) PIN_NUMBER(ROW_GROUP_A(r), c)
> >>
> >> You add these #defines but do not use them.
> >
> > ehm, actually I do:
> 
> Argh I was just wrong, forget about this.
> 
> Woudl really like Laurent's ACK on this before I apply it though.

Laurent, ping.
