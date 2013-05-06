Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691Ab3EFWmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:42:33 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:40697 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758561Ab3EFWmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:42:31 -0400
From: "Ortiz, Lance E" <lance.oritz@hp.com>
To: Borislav Petkov <bp@alien8.de>
CC: =?utf-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-ACPI <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Dall, Elizabeth J (MCLinux)" <betty.dall@hp.com>
Subject: RE: WARNING at drivers/pci/search.c:214 for 3.9
Thread-Topic: WARNING at drivers/pci/search.c:214 for 3.9
Thread-Index: AQHOSmT7XmlaV8+Pw0um1uzzkieDY5j4QjGAgABv+XWAAA0fMA==
Date: Mon, 6 May 2013 22:40:56 +0000
Message-ID: <A961433CDFF2F640A2866803152E61F9517726BE@G9W0715.americas.hpqcorp.net>
References: <20130506162112.6b79b7b1@pluto.restena.lu>
 <20130506150757.GC22041@pd.tnic>
 <A961433CDFF2F640A2866803152E61F951772648@G9W0715.americas.hpqcorp.net>
 <20130506214913.GE22041@pd.tnic>
In-Reply-To: <20130506214913.GE22041@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.31]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r46Mgdvf027400

> Hmm, not sure.
> 
> Off the top of my head, maybe add the whole code around:
> 
> #ifdef CONFIG_ACPI_APEI_PCIEAER
> ...
> 
> #endif
> 
> in cper_print_pcie() into a separate function which is called from a
> workqueue right after the interrupt is done.. Or something to that
> effect.
> 
Thanks.  Let me see what I can put together.  I have some ideas.

Lance
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
