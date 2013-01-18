Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279Ab3ARHHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 02:07:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50006 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951Ab3ARHHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 02:07:11 -0500
Date: Fri, 18 Jan 2013 16:07:04 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Milo Kim <milo.kim@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: lp872x: Remove _rdev_to_offset() function
Message-ID: <20130118070702.GD4960@opensource.wolfsonmicro.com>
References: <1358476199.25899.3.camel@phoenix>
 <20130118062510.GC4960@opensource.wolfsonmicro.com>
 <CAFRkauDrC56esDk_NK9aEbxrzUZMC=eeD_hQSwG1JLNBY0Bh0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFRkauDrC56esDk_NK9aEbxrzUZMC=eeD_hQSwG1JLNBY0Bh0A@mail.gmail.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 03:04:59PM +0800, Axel Lin wrote:
> 2013/1/18 Mark Brown <broonie@opensource.wolfsonmicro.com>
> > On Fri, Jan 18, 2013 at 10:29:59AM +0800, Axel Lin wrote:
> > > There is only one caller calling _rdev_to_offset(), and the code
> > > looks simper if we remove _rdev_to_offset(). Thus remove it.

> > This doesn't seem to apply to topic/lp872x?

> I cannot find topic/lp872x branch on your tree.
> I generate the patch against linux-next.

I'd forgotten to push it out, done now - actually looks to be pretty
much the same code.
