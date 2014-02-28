Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaB1M35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 07:29:57 -0500
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:54876 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaB1M3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 07:29:55 -0500
Message-ID: <1393590591.13669.36.camel@dubbel>
Subject: Re: [PATCH v4 0/8] wilink: add device tree support
From: Luca Coelho <luca@coelho.fi>
To: Yegor Yefremov <yegorslists@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        "Nori, Sekhar" <nsekhar@ti.com>, mturquette@linaro.org,
        mark.rutland@arm.com, balbi@ti.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, nm@ti.com,
        martinez.javier@gmail.com
Date: Fri, 28 Feb 2014 14:29:51 +0200
In-Reply-To: <CAGm1_kvdzkvzEEymQ+H0XiKugifHF27KDz3jwX5Frg_U=S7KgA@mail.gmail.com>
References: <1375189476-21557-1-git-send-email-coelho@ti.com>
	 <CAGm1_kvdzkvzEEymQ+H0XiKugifHF27KDz3jwX5Frg_U=S7KgA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-28 at 08:26 +0100, Yegor Yefremov wrote:
> On Tue, Jul 30, 2013 at 3:04 PM, Luciano Coelho <coelho@ti.com> wrote:
> > Hi,
> >
> > This patch series adds device tree support to the wlcore_sdio driver,
> > which is used by WiLink6, WiLink7 and WiLink8.
> >
> > The first patches do some clean-up to make the data needed in the
> > wilink device tree node smaller.  The remaining patches implement the
> > actual device tree node parsing in wlcore_sdio.
> >
> > Regarding the XTAL clock issues, for now we don't support XTAL mode
> > with DT, but I have sent a proposal for a small change in the clock
> > framework to support this, but it's still under discussions [1].
> >
> > The DTS file changes will be sent separately, since they need to go
> > via different trees.
> >
> > A new version of the bindings documentation has been sent [2] and, if
> > no more comments are given to it, I'll apply it via my tree.
> >
> > [1] http://news.gmane.org/find-root.php?message_id=1372971912-10877-1-git-send-email-coelho@ti.com
> > [2] http://news.gmane.org/find-root.php?message_id=1375109728-5931-1-git-send-email-coelho@ti.com
> >
> > Changes in v4:
> >
> > * Rebased on top of 3.11-rc3 (eg. no more changes on the board files
> >   that were removed);
> >
> > * Use the new irq_get_trigger_type() instead of
> >   irqd_get_trigger_type() (thanks Javier);
> >
> > * Added some missing const's (thanks Felipe);
> >
> > * Reverted Tony's workaround to get WiLink to work on Panda while DT
> >   was not supported yet.
> >
> >
> > Please review.
> 
> What is the state of the series? Who is now responsible for the
> patches? What issues were still not handled?

There were some comments about this series (or more precisely, the one
that added the bindings documentation[1]).  Unfortunately, I have left
TI since and have no time to handle them.  Feel free to pick it up and
continue from there.

[1] https://lkml.org/lkml/2013/7/30/712

--
Cheers,
Luca.

