Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab3GCNqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 09:46:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54499 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174Ab3GCNqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 09:46:33 -0400
Message-ID: <1372859132.21065.111.camel@cumari.coelho.fi>
Subject: Re: [PATCH v2 0/9] wilink: add device tree support
From: Luciano Coelho <coelho@ti.com>
To: Grazvydas Ignotas <notasas@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Tony Lindgren" <tony@atomide.com>, <nsekhar@ti.com>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>,
        Felipe Balbi <balbi@ti.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <pavel@ucw.cz>
Date: Wed, 3 Jul 2013 16:45:32 +0300
In-Reply-To: <CANOLnOPBHesTiV61zpQ_QS9c7E91K50EnbMnGhvgaViuA_3=Bw@mail.gmail.com>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
	 <CANOLnOPBHesTiV61zpQ_QS9c7E91K50EnbMnGhvgaViuA_3=Bw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 13:13 +0300, Grazvydas Ignotas wrote:
> Hi,

Hi Gražvydas,


> On Tue, Jul 2, 2013 at 5:55 PM, Luciano Coelho <coelho@ti.com> wrote:
> > Hi,
> >
> > This is a follow-up on a previous patch set that had a smaller
> > audience.  This time, I added the lists and people who were involved
> > in the review of the bindings documentation, since most of my changes
> > in v2 are coming from discussions there.
> >
> > This patch series adds device tree support to the wlcore_sdio driver,
> > which is used by WiLink6, WiLink7 and WiLink8.
> 
> Could you perhaps consider doing device tree conversion for wl1251
> too? With the knowledge you have from working on this series, it would
> be much easier for you to do it than for someone else, and I don't
> have much hope someone will do it at all. It's WiLink series chip
> after all. Without this pandora and N900 are going to lose wifi
> support after the switch to dt-only kernel.

Unfortunately I don't have much time to work on wl1251.  I think it
wouldn't be too difficult to do though, so patches are welcome. ;)

Maybe you could try to make this change and I could support you if
needed?


> I can offer you my help testing things on pandora and I'm sure someone
> here could try it on N900.

I could try it on the N900, if it is still bootable easily with the
mainline. ;)

--
Cheers,
Luca.

