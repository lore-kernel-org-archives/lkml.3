Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab3E2Nme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:42:34 -0400
Received: from mx0.aculab.com ([213.249.233.131]:36028 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759457Ab3E2Nmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:42:32 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH v6 net-next 2/5] net: implement support for low latency socket polling
Date: Wed, 29 May 2013 14:42:11 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7257@saturn3.aculab.com>
In-Reply-To: <1369834647.5109.15.camel@edumazet-glaptop>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v6 net-next 2/5] net: implement support for low latency socket polling
Thread-Index: Ac5cceNVsrBIaxAhS62dvUg8nsPAPAAADkmw
References: <20130529063916.27486.3841.stgit@ladj378.jer.intel.com> <20130529063935.27486.18610.stgit@ladj378.jer.intel.com> <1369834647.5109.15.camel@edumazet-glaptop>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4TDgcqS009569

> > +/* we don't mind a ~2.5% imprecision */
> > +#define TSC_MHZ (tsc_khz >> 10)

Wouldn't (tsc_khz << 10) be better?

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
