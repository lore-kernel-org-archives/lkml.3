Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab3CNSbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 14:31:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59682 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab3CNSbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 14:31:08 -0400
From: "Anna, Suman" <s-anna@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>
Subject: RE: [PATCHv3 03/14] mailbox: OMAP: introduce mailbox framework
Thread-Topic: [PATCHv3 03/14] mailbox: OMAP: introduce mailbox framework
Thread-Index: AQHOH5rnfMcntSyh8kCsyEL56+3TdpikPcYA///mG1CAAQidAIAAV30w
Date: Thu, 14 Mar 2013 18:30:45 +0000
Message-ID: <37C860A02101E749A747FA2D3C1E3C50499EBA@DLEE11.ent.ti.com>
References: <1363145044-14442-1-git-send-email-s-anna@ti.com>
	<CACRpkdY8ZWNUVHJorbhN7XvOys9KJH8hKeCBYARih=1FiNk-CQ@mail.gmail.com>
	<37C860A02101E749A747FA2D3C1E3C50498B8E@DLEE11.ent.ti.com>
 <CACRpkdbUBkhkQ-ZiqkLUmsDBp3hw4k3Z1s4i4SD3C2ZfuGUF+w@mail.gmail.com>
In-Reply-To: <CACRpkdbUBkhkQ-ZiqkLUmsDBp3hw4k3Z1s4i4SD3C2ZfuGUF+w@mail.gmail.com>
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

> On Wed, Mar 13, 2013 at 10:34 PM, Anna, Suman <s-anna@ti.com> wrote:
> >> On Wed, Mar 13, 2013 at 4:24 AM, Suman Anna <s-anna@ti.com> wrote:
> >>
> >> > From: Omar Ramirez Luna <omar.luna@linaro.org>
> >> (...)
> >> >
> >> > Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
> >> > [s-anna@ti.com: Kconfig fixes for build errors]
> >> > Signed-off-by: Suman Anna <s-anna@ti.com>
> >> > Acked-by: Tony Lindgren <tony@atomide.com>
> >> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> >>
> >> It's not like I care super-much, but I think your SoB should be at the bottom.
> >>
> >> It's a simple git rebase -i anyway...
> >
> > Sure, will do. Only this patch, right? I have my SoB only on one another original
> patch, will adjust on that as well, but all the remaining ones will have yours at the
> bottom.
> 
> No I mean that the SoB-order should reflect the code flow path, and yours should
> be at the bottom of all of them, but as noted I don't care much. In my case the
> only thing I did was to pass the code :-)

Thanks for the clarification. I have updated the branch accordingly.

Regards,
Suman
