Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab3FGOJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:09:49 -0400
Received: from mx0.aculab.com ([213.249.233.131]:35169 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752540Ab3FGOJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:09:48 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: Scaling problem with a lot of AF_PACKET sockets on different interfaces
Date: Fri, 7 Jun 2013 15:09:02 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B727D@saturn3.aculab.com>
In-Reply-To: <1370613289.24311.419.camel@edumazet-glaptop>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Scaling problem with a lot of AF_PACKET sockets on different interfaces
Thread-Index: Ac5jhpjrmzBEOcM7SvW9SCw7ZTjHeQAAde1Q
References: <51B1CA50.30702@telenet.dn.ua> <1370608871.5854.64.camel@marge.simpson.net> <AE90C24D6B3A694183C094C60CF0A2F6026B727B@saturn3.aculab.com> <1370613289.24311.419.camel@edumazet-glaptop>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: "Mike Galbraith" <bitbucket@online.de>,
        "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>,
        <linux-kernel@vger.kernel.org>, "netdev" <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r57E9rvU020751

> > Looks like the ptype_base[] should be per 'dev'?
> > Or just put entries where ptype->dev != null_or_dev on a per-interface
> > list and do two searches?
> 
> Yes, but then we would have two searches instead of one in fast path.

Usually it would be empty - so the search would be very quick!

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
