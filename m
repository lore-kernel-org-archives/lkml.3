Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaFMIuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 04:50:13 -0400
Received: from mx0.aculab.com ([213.249.233.131]:40319 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752938AbaFMIuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 04:50:09 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        Tom Herbert <therbert@google.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Linux-Next <linux-next@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [-next] Regression: ssh log in slowdown
Thread-Topic: [-next] Regression: ssh log in slowdown
Thread-Index: AQHPhuOEjg6tqmc0skKORvvtsE7uQJtuurFw
Date: Fri, 13 Jun 2014 08:49:11 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1725C134@AcuExch.aculab.com>
References: <alpine.DEB.2.02.1406130111280.1551@tomh.mtv.corp.google.com>
 <CAMuHMdW4kYeqEby3iABzdbjyAkPKq=x4dyopokFbHWT0Q4fjcw@mail.gmail.com>
In-Reply-To: <CAMuHMdW4kYeqEby3iABzdbjyAkPKq=x4dyopokFbHWT0Q4fjcw@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5D8oK3U012987

From: Of Geert Uytterhoeven
...
> Note that I'm also using NFS root, which doesn't seem to be affected.
> I can happily run "ls -R /" on the serial console during the 10 s delay in ssh.

Are you sure that the delay during ssh login isn't just
a reverse DNS timeout?

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
