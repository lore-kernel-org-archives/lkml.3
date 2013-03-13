Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934320Ab3CMVe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 17:34:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33759 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932597Ab3CMVez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 17:34:55 -0400
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
Thread-Index: AQHOH5rnfMcntSyh8kCsyEL56+3TdpikPcYA///mG1A=
Date: Wed, 13 Mar 2013 21:34:36 +0000
Message-ID: <37C860A02101E749A747FA2D3C1E3C50498B8E@DLEE11.ent.ti.com>
References: <1363145044-14442-1-git-send-email-s-anna@ti.com>
 <CACRpkdY8ZWNUVHJorbhN7XvOys9KJH8hKeCBYARih=1FiNk-CQ@mail.gmail.com>
In-Reply-To: <CACRpkdY8ZWNUVHJorbhN7XvOys9KJH8hKeCBYARih=1FiNk-CQ@mail.gmail.com>
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

> On Wed, Mar 13, 2013 at 4:24 AM, Suman Anna <s-anna@ti.com> wrote:
> 
> > From: Omar Ramirez Luna <omar.luna@linaro.org>
> (...)
> >
> > Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
> > [s-anna@ti.com: Kconfig fixes for build errors]
> > Signed-off-by: Suman Anna <s-anna@ti.com>
> > Acked-by: Tony Lindgren <tony@atomide.com>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> It's not like I care super-much, but I think your SoB should be at the bottom.
> 
> It's a simple git rebase -i anyway...

Sure, will do. Only this patch, right? I have my SoB only on one another original patch, will adjust on that as well, but all the remaining ones will have yours at the bottom.

Regards
Suman
