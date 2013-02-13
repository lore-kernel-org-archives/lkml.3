Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934547Ab3BMQmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:42:47 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47506 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758775Ab3BMQmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:42:43 -0500
From: "Anna, Suman" <s-anna@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>, Paul Walmsley <paul@pwsan.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Tejun Heo <tj@kernel.org>, Omar Ramirez Luna <omar.luna@linaro.org>
Subject: RE: [PATCH v2 00/13] drivers: mailbox: framework creation
Thread-Topic: [PATCH v2 00/13] drivers: mailbox: framework creation
Thread-Index: AQHOCN4g9GGzQKOQDkGhWHRVoYbj7ph4MR0AgAABkID//8xYQA==
Date: Wed, 13 Feb 2013 16:41:37 +0000
Message-ID: <37C860A02101E749A747FA2D3C1E3C50476638@DLEE12.ent.ti.com>
References: <1360645032-9668-1-git-send-email-s-anna@ti.com>
 <CACRpkdZayg-X11ZRnh2Z0i+egBn8Fhwya-6_Yr8wcv+6s0CVqQ@mail.gmail.com>
 <20130213134207.GN17852@n2100.arm.linux.org.uk>
In-Reply-To: <20130213134207.GN17852@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Feb 13, 2013 at 02:36:32PM +0100, Linus Walleij wrote:
> > On Tue, Feb 12, 2013 at 5:56 AM, Suman Anna <s-anna@ti.com> wrote:
> >
> > > I have hosted the series at [3].
> > > [3]
> > > https://github.com/sumananna/mailbox/commits/dbx500-prcmu-mailbox
> >
> > Suman, I suggest you ask Stepgen Rothwell to include this branch into
> > the linux-next tree, so we can get some rotation of this stuff in
> > preparation for the v3.10 merge window. (It's not going in now
> > anyway.)
> 
> Best wait until after v3.9-rc1 - remember that linux-next is supposed to be a
> staging tree for the _next_ merge window only.

Yes, will do. Anyway, we need a new revision of one patch (so far) to address Mark Rutland's comments.

Thanks
Suman
