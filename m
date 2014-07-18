Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761496AbaGRKr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:47:29 -0400
Received: from gloria.sntech.de ([95.129.55.99]:40464 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761234AbaGRKr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:47:27 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko.stuebner@bq.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        grant.likely@linaro.org, thierry.reding@gmail.com,
        florian.vaussard@epfl.ch, jic23@kernel.org, jason@lakedaemon.net,
        andrew@lunn.ch, silvio.fricke@gmail.com, olof@lixom.net,
        sebastian.hesselbarth@gmail.com, sboyd@codeaurora.org,
        gregory.clement@free-electrons.com, arnd@arndb.de,
        robherring2@gmail.com, marc.zyngier@arm.com,
        maxime.ripard@free-electrons.com, soren.brinkmann@xilinx.com,
        shawn.guo@freescale.com, anders.berg@lsi.com, linus.walleij@linaro.org,
        ak@linux.intel.com, hpa@linux.intel.com, akpm@linux-foundation.org,
        u.kleine-koenig@pengutronix.de, gregkh@linuxfoundation.org,
        fabf@skynet.be, rostedt@goodmis.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v10 5/7] arm: add basic support for Mediatek MT6589 boards
Date: Fri, 18 Jul 2014 12:47:53 +0200
Message-ID: <127793649.dTvqVjg5LM@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <53C8ED0B.5080802@linaro.org>
References: <1404745988-32558-1-git-send-email-matthias.bgg@gmail.com> <1404745988-32558-6-git-send-email-matthias.bgg@gmail.com> <53C8ED0B.5080802@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Am Freitag, 18. Juli 2014, 11:46:51 schrieb Daniel Lezcano:
> On 07/07/2014 05:13 PM, Matthias Brugger wrote:
> > This adds a generic devicetree board file and a dtsi for boards
> > based on MT6589 SoCs from Mediatek.
> > 
> > Apart from the generic parts (gic, clocks) the only component
> > currently supported are the timers.
> > 
> > Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> > --
> 
> I will take this patchset through my tree but this patch touches an area
> I am not handling.
> 
> Olof, Arnd, do you mind to ack this patch ?

wouldn't it be easier to just take patches 1,2,3,4 through your tree and let 
patches 5,6,7 go through arm-soc?

There is no compile-time dependency between the two parts, so they will come 
together nicely in linux-next and during the merge-window.


Also in [0] Olof wrote:

----------
Traditionally we usually take the DT changes through arm-soc, but as
long as we share the branch we might be ok. We tend to stick them in
different branches in our tree though, so rockchip will be a little
mis-sorted this release. Not a big deal, and we can deal with it.
-----------

So I'd assume splitting the patchset this way might be a nice solution?


Heiko


[0] http://www.spinics.net/lists/arm-kernel/msg347053.html
