Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab3FCMsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:48:11 -0400
Received: from mx0.aculab.com ([213.249.233.131]:60820 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755912Ab3FCMsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:48:09 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH v2] include/linux/skbuff.h: using '(u16) ~0U' instead of '~0U'
Date: Mon, 3 Jun 2013 13:47:24 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7263@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7262@saturn3.aculab.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2] include/linux/skbuff.h: using '(u16) ~0U' instead of '~0U'
Thread-Index: Ac5gTP47znuaL0AITMyRQ3C0h7fPxgACE3hgAADCULA=
References: <51A6EBC5.7040601@asianux.com> <CAHp75VfWvXkaoYQ_40idSsLYUA=YqaswnV2y-hODHjt7JMHQvQ@mail.gmail.com> <51AC60AA.8010107@asianux.com> <CAHp75Vc19Kii7_TF+9aF4ZeKAa4_92DCVL+u1duZDTu38o2qsw@mail.gmail.com> <51AC7546.4010002@asianux.com> <51AC7CD4.2060801@asianux.com> <AE90C24D6B3A694183C094C60CF0A2F6026B7262@saturn3.aculab.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "David Laight" <David.Laight@ACULAB.COM>,
        "Chen Gang" <gang.chen@asianux.com>,
        "Andy Shevchenko" <andy.shevchenko@gmail.com>, <edumazet@google.com>
Cc: "Pravin Shelar" <pshelar@nicira.com>, <mgorman@suse.de>,
        "David Miller" <davem@davemloft.net>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "netdev" <netdev@vger.kernel.org>,
        "Ben Hutchings" <bhutchings@solarflare.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r53CmIMj007266

> > +#define SKB_HEADER_UNSET_16	((unsigned short) ~0U)
> > +
> 
> The _16 part isn't really correct, the type could be changed
> and then it would be wrong.
> 
> I think I might have used SKB_HEADER_OFFSET.

I meant SKB_HEADER_UNSET_OFFSET or SKB_HEADER_OFFSET_UNSET

> NrybXÇ§v^)Şº{.n+z^)w*jgİ¢j/zŞ–2Ş™&)ß¡aGhj:+vwÙ¥

I've NFI what adds this!

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
