Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbaLDP5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:57:14 -0500
Received: from mx0.aculab.com ([213.249.233.131]:58822 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932271AbaLDP5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:57:11 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>,
        Daniel Borkmann <dborkman@redhat.com>
CC: Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: Where exactly will arch_fast_hash be used
Thread-Topic: Where exactly will arch_fast_hash be used
Thread-Index: AQHQD9mRZIXhcRntwEWusNXUzWNWJJx/lMQQ
Date: Thu, 4 Dec 2014 15:56:30 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CA0284A@AcuExch.aculab.com>
References: <20141204081147.GA19030@gondor.apana.org.au>
 <20141204152637.GA32140@casper.infradead.org>
 <20141204152929.GA22075@gondor.apana.org.au>
 <20141204153938.GC32140@casper.infradead.org> <54808123.8000704@redhat.com>
 <20141204154708.GA22185@gondor.apana.org.au>
In-Reply-To: <20141204154708.GA22185@gondor.apana.org.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu
> On Thu, Dec 04, 2014 at 04:43:31PM +0100, Daniel Borkmann wrote:
> >
> > Hm, I thought the kernel doc on arch_fast_hash() in include/linux/hash.h
> > would give enough of a hint ...
> 
> I think something more explicit like "do not use this in a hash
> table unless you know what you're doing" might be needed.

That isn't really helpful. Maybe something more like:

"This CRC algorithm used by this hash is 'linear', ie hash(a xor b) ==
hash(a) xor hash(b). This means that it is relatively easy for a remote
attacker to generate multiple items with the same hash."

	David



