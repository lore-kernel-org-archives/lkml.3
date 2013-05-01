Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab3EAXFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 19:05:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40156 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757335Ab3EAXFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 19:05:18 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Randy Dunlap <rdunlap@infradead.org>, Anton Vorontsov <cbou@mail.ru>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: RE: [PATCH -next] power: fix lp8788-charger kconfig & build
Thread-Topic: [PATCH -next] power: fix lp8788-charger kconfig & build
Thread-Index: AQHORqDFhU1nKr/7p0mTe4t5m2cghJjw8nGQ
Date: Wed, 1 May 2013 23:04:38 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E5C1EC@DQHE06.ent.ti.com>
References: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au>
 <51816A93.4070802@infradead.org>
In-Reply-To: <51816A93.4070802@infradead.org>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Randy Dunlap [mailto:rdunlap@infradead.org]
> Sent: Thursday, May 02, 2013 4:19 AM
> To: Stephen Rothwell
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Kim, Milo;
> Anton Vorontsov; David Woodhouse
> Subject: [PATCH -next] power: fix lp8788-charger kconfig & build
> 
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build errors in lp8788-charger by making it depend on IIO.
> Fixes errors when CONFIG_IIO=m and CHARGER_LP8788=y.
> 
> lp8788-charger.c:(.text+0x2146b5): undefined reference to
> `iio_channel_get'
> lp8788-charger.c:(.text+0x2146ce): undefined reference to
> `iio_channel_get'
> lp8788-charger.c:(.text+0x214a86): undefined reference to
> `iio_read_channel_processed'
> lp8788-charger.c:(.text+0x214b51): undefined reference to
> `iio_read_channel_processed'
> lp8788-charger.c:(.text+0x214c30): undefined reference to
> `iio_read_channel_processed'
> lp8788-charger.c:(.text+0x214d93): undefined reference to
> `iio_channel_release'
> lp8788-charger.c:(.text+0x214dac): undefined reference to
> `iio_channel_release'

Thanks for fixing this.

Acked-by: Milo Kim <milo.kim@ti.com>

