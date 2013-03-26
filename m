Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201Ab3CZTbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:31:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46770 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757271Ab3CZTbE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:31:04 -0400
From: "Anna, Suman" <s-anna@ti.com>
To: Paul Walmsley <paul@pwsan.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, "Arnd Bergmann" <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>
Subject: RE: [PATCHv3 02/14] ARM: OMAP2+: mbox: remove dependencies with
 soc.h
Thread-Topic: [PATCHv3 02/14] ARM: OMAP2+: mbox: remove dependencies with
 soc.h
Thread-Index: AQHOH5riWnqv9W8ld0GOuM12zVjHn5i4uVsA//+22CA=
Date: Tue, 26 Mar 2013 19:30:41 +0000
Message-ID: <37C860A02101E749A747FA2D3C1E3C5049F528@DLEE11.ent.ti.com>
References: <1363145036-14407-1-git-send-email-s-anna@ti.com>
 <alpine.DEB.2.00.1303261845390.23957@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1303261845390.23957@utopia.booyaka.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

> > The OMAP mailbox platform driver code has been cleaned up to remove
> > the dependencies with soc.h in preparation for moving the mailbox code
> > to drivers folder.
> >
> > The code relied on cpu_is_xxx/soc_is_xxx macros previously to pick the
> > the right set of mailbox devices and register with the mailbox driver.
> > This data is now represented in a concise format and moved to the
> > respective omap_hwmod data files and published to the driver through
> > the platform data.
> >
> > Signed-off-by: Suman Anna <s-anna@ti.com>
> 
> The hwmod/dev_attr parts look fine to me, but please start thinking about how
> to convert the driver to get this data from DT instead.

Yes, that is the plan. I will have the DT conversion when I add the support for
OMAP5.

Regards
Suman

