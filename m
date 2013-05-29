Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966149Ab3E2NKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:10:05 -0400
Received: from mx0.aculab.com ([213.249.233.131]:35491 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965945Ab3E2NKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:10:01 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH v6 net-next 1/5] net: add napi_id and hash
Date: Wed, 29 May 2013 14:09:10 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7256@saturn3.aculab.com>
In-Reply-To: <1369832201.5109.8.camel@edumazet-glaptop>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v6 net-next 1/5] net: add napi_id and hash
Thread-Index: Ac5cbBknTjTZktxGSz2U1e45Dwt3JwAAQHVg
References: <20130529063916.27486.3841.stgit@ladj378.jer.intel.com> <20130529063925.27486.46649.stgit@ladj378.jer.intel.com> <1369832201.5109.8.camel@edumazet-glaptop>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Eliezer Tamir" <eliezer.tamir@linux.intel.com>
Cc: "David Miller" <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        "Don Skidmore" <donald.c.skidmore@intel.com>,
        <e1000-devel@lists.sourceforge.net>,
        "Willem de Bruijn" <willemb@google.com>,
        "Andi Kleen" <andi@firstfloor.org>, "HPA" <hpa@zytor.com>,
        "Eilon Greenstien" <eilong@broadcom.com>,
        "Or Gerlitz" <or.gerlitz@gmail.com>,
        "Alex Rosenbaum" <alexr@mellanox.com>,
        "Eliezer Tamir" <eliezer@tamir.org.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4TDAEJp009390

> > Adds a napi_id and a hashing mechanism to lookup a napi by id.

Is this one of the places where the 'id' can be selected
so that the 'hash' lookup never collides?

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
