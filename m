Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbaDVVIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:08:55 -0400
Received: from fujitsu25.fnanic.fujitsu.com ([192.240.6.15]:49759 "EHLO
	fujitsu25.fnanic.fujitsu.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752269AbaDVUSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:18:38 -0400
From: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
To: Davidlohr Bueso <davidlohr@hp.com>,
        Manfred Spraul <manfred@colorfullife.com>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki JP <kosaki.motohiro@jp.fujitsu.com>,
        "gthelen@google.com" <gthelen@google.com>,
        "aswin@hp.com" <aswin@hp.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Tue, 22 Apr 2014 13:16:38 -0700
Subject: RE: [PATCH 3/4] ipc/shm.c: check for integer overflow during shmget.
Thread-Topic: [PATCH 3/4] ipc/shm.c: check for integer overflow during
 shmget.
Thread-Index: Ac9eV2DClosdxWOdShqJG1lf929rngAEFWSQ
Message-ID: <6B2BA408B38BA1478B473C31C3D2074E30989E9D81@SV-EXCHANGE1.Corp.FC.LOCAL>
References: <1398090397-2397-1-git-send-email-manfred@colorfullife.com>
	 <1398090397-2397-2-git-send-email-manfred@colorfullife.com>
	 <1398090397-2397-3-git-send-email-manfred@colorfullife.com>
	 <1398090397-2397-4-git-send-email-manfred@colorfullife.com>
 <1398190745.2473.10.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1398190745.2473.10.camel@buesod1.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-22_07:2014-04-22,2014-04-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3ML92qA012712

> > SHMMAX is the upper limit for the size of a shared memory segment,
> > counted in bytes. The actual allocation is that size, rounded up to
> > the next full page.
> > Add a check that prevents the creation of segments where the rounded
> > up size causes an integer overflow.
> >
> > Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> 
> Acked-by: Davidlohr Bueso <davidlohr@hp.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
