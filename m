Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaJHJMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:12:01 -0400
Received: from mx0.aculab.com ([213.249.233.131]:36609 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754992AbaJHJLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:11:55 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Hannes Frederic Sowa'" <hannes@stressinduktion.org>,
        Fabian Frederick <fabf@skynet.be>
CC: Guenter Roeck <linux@roeck-us.net>, David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1 net-next] af_unix: remove NULL assignment on static
Thread-Topic: [PATCH 1/1 net-next] af_unix: remove NULL assignment on static
Thread-Index: AQHP4nDaY/3w3KaSUkWpLu0HQtjtIJwl6V3A
Date: Wed, 8 Oct 2014 09:10:23 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D174C6CA5@AcuExch.aculab.com>
References: <1412712996-4672-1-git-send-email-fabf@skynet.be>
	 <20141007.161832.453892039501955243.davem@davemloft.net>
	 <20141007203344.GA4748@roeck-us.net>
	 <1559212122.19553.1412714971908.open-xchange@webmail.nmp.skynet.be>
 <1412715283.11600.11.camel@localhost>
In-Reply-To: <1412715283.11600.11.camel@localhost>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id s989C9Wg023285

From: Hannes Frederic Sowa
> I think David's concern was whether if 0 == false in all situations. It
> is pretty clear that static memory is initialized to 0.

I'm not 100% sure about that.
static pointers may be required to be initialised to NULL.
If NULL isn't the 'all 0 bit pattern' then the memory would need
to be initialised to a different pattern.
Not that anyone is likely to implement such a system because far too
much code will break.

The only system I knew where 'native' NULL pointers were 'all 1s'
used 0 in its C compiler.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
