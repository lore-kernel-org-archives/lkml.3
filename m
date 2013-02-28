Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab3B1X0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:26:07 -0500
Received: from sauhun.de ([89.238.76.85]:43336 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab3B1X0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:26:03 -0500
Date: Fri, 1 Mar 2013 00:25:58 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 0/2] Add automatic bus number support for i2c busses
 with device tree
Message-ID: <20130228232558.GA8180@the-dreams.de>
References: <1360630085-26874-1-git-send-email-dianders@chromium.org>
 <CAD=FV=WS5Vj74d-FNXCVpNsx6Nf-8+RC-WO29Z1XNmkEOYLxfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=WS5Vj74d-FNXCVpNsx6Nf-8+RC-WO29Z1XNmkEOYLxfQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Doug Anderson (2):
> >   i2c-core: dt: Pick i2c bus number from i2c alias if present
> >   i2c: pxa: Use i2c-core to get bus number now
> >
> >  drivers/i2c/busses/i2c-pxa.c | 20 ++++++++--------
> >  drivers/i2c/i2c-core.c       | 54 ++++++++++++++++++++++++++++++++------------
> >  2 files changed, 49 insertions(+), 25 deletions(-)
> 
> Is there anything else needed for this patch series?  It's been
> hanging around for quite a while and it would be nice to see it land.
> If you're waiting for additional acks or reviews I'll ask around and
> see if I can get them...

Regarding patch 1, I was waiting for the idr changes to hit mainline.
They are mainline now, but since the removal of MAX_IDR_MASK your patch
doesn't apply anymore :( Can you rebase and retest, please? I'd like to
get it into 3.9, still.

For patch 2, some Tested-by would be nice; but it will probably make it
into my for-next somewhen after rc1 is out.

Thanks,

   Wolfram

