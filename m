Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaEWPbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:31:36 -0400
Received: from mx0.aculab.com ([213.249.233.131]:59422 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751387AbaEWPbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:31:21 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Eric Dumazet'" <eric.dumazet@gmail.com>,
        Jim Baxter <jim_baxter@mentor.com>
CC: =?utf-8?B?J0Jqw7hybiBNb3JrJw==?= <bjorn@mork.no>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "kamal@canonical.com" <kamal@canonical.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>, "fw@strlen.de" <fw@strlen.de>
Subject: RE: skbuff truesize incorrect.
Thread-Topic: skbuff truesize incorrect.
Thread-Index: AQHPdmwmL2lnKeimqUeV55a8ET8tq5tN+mog///3/4CAACsHgIAAJ6iA
Date: Fri, 23 May 2014 15:30:37 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1724CACF@AcuExch.aculab.com>
References: <537E4AFD.20304@mentor.com>
		<1400792295.5367.174.camel@edumazet-glaptop2.roam.corp.google.com>
		<063D6719AE5E284EB5DD2968C1650D6D1724C490@AcuExch.aculab.com>
	 <87r43k4yhe.fsf@nemi.mork.no>
	 <063D6719AE5E284EB5DD2968C1650D6D1724C7A1@AcuExch.aculab.com>
	 <537F2D53.5020408@mentor.com>
 <1400852843.5367.191.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1400852843.5367.191.camel@edumazet-glaptop2.roam.corp.google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4NFVqAv004052

From: Eric Dumazet
...
> TCP stack uses fast clones, and current stack gives them a truesize of
> 2048 + sizeof(sk_buff), while it really should be 2048 +
> 2*sizeof(sk_buff)
> 
> Luckily, GSO/TSO tends to reduce the error, as skbs overhead is lower.

Doesn't that affect the tx side - where the truesize doesn't matter as much?

	David


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
