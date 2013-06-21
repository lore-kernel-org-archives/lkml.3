Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423334Ab3FUQkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:40:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51185 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161494Ab3FUQk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:40:29 -0400
From: "Anna, Suman" <s-anna@ti.com>
To: Tony Lindgren <tony@atomide.com>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: RE: linux-next: manual merge of the arm-soc tree with the mailbox
 tree
Thread-Topic: linux-next: manual merge of the arm-soc tree with the mailbox
 tree
Thread-Index: AQHObkWxiMg6k5XOD0ix44UDy8z8q5lADRgAgABRWXA=
Date: Fri, 21 Jun 2013 16:39:57 +0000
Message-ID: <37C860A02101E749A747FA2D3C1E3C504CDAAE@DLEE11.ent.ti.com>
References: <20130621160800.64f9965229e5042a7b77e212@canb.auug.org.au>
 <20130621064526.GJ5523@atomide.com>
In-Reply-To: <20130621064526.GJ5523@atomide.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5LGeeMF009938

> * Stephen Rothwell <sfr@canb.auug.org.au> [130620 23:14]:
> > Hi all,
> >
> > Today's linux-next merge of the arm-soc tree got a conflict in
> > arch/arm/mach-omap2/devices.c between commit 4a1c0e83bb4e ("ARM:
> OMAP2+:
> > mbox: remove dependencies with soc.h") from the mailbox tree and commit
> > 82c5cde1c4b0 ("ARM: OMAP2+: Remove omap4 ocp2scp pdata") from the arm-
> soc
> > tree.
> >
> > I fixed it up (removing the include of
> > linux/platform_data/omap_ocp2scp.h) and can carry the fix as necessary
> > (no action is required).
> 
> Thanks, that's the right fix as that header won't be needed any longer
> as we've made omap4 device tree only.
> 
> > That mailbox tree commit looks very similar to commit b8a7cf8e2b15 ("ARM:
> > OMAP2+: mbox: remove dependencies with soc.h") from the arm-soc tree ...
> 
> The earlier mailbox branch was merged into arm-soc for a few weeks until
> we decided to drop it as Jassi is working on a more generic API. That was
> merged in commit 51b5f893, then reverted in commit b5c85186. The updated
> mailbox branch accounts for the generic API coming up from Jassi.
> 
> Suman, can you please check if Linux next has mailbox related files merged
> correctly?

Yes, they look good.

Regards
Suman
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
