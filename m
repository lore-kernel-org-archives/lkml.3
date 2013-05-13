Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3EMGZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 02:25:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41442 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab3EMGZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 02:25:28 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] spi/omap2: Let device core handle pinctrl
Thread-Topic: [PATCH] spi/omap2: Let device core handle pinctrl
Thread-Index: AQHOSpEtMssOEU4sAUGUr3i0BAEdV5j5FsQg///PQ4CAAKQJQIAEI/qAgAUBrnA=
Date: Mon, 13 May 2013 06:25:12 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EBEA4CC@DBDE04.ent.ti.com>
References: <1367868998-12667-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1BAFE6F6C881BF42822005164F1491C33EBE473A@DBDE04.ent.ti.com>
 <20130507085535.GN7478@sirena.org.uk>
 <1BAFE6F6C881BF42822005164F1491C33EBE4E07@DBDE04.ent.ti.com>
 <20130510095629.GM3200@sirena.org.uk>
In-Reply-To: <20130510095629.GM3200@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 15:26:29, Mark Brown wrote:
> On Tue, May 07, 2013 at 10:47:31AM +0000, Hebbar, Gururaja wrote:
> > On Tue, May 07, 2013 at 14:25:35, Mark Brown wrote:
> 
> > > There's also been some discussion about factoring out the suspend/resume
> > > code since it's going to get equally repetitive.
> 
> > Really. Any link/referenceso that I can follow.
> > But I think each module will have its own work to do. May be I can confirm once 
> > I look at the factoring-out discussion.
> 
> It was part of the threads where the idea of adding the helper for the
> boilerplate stuff to the core was discussed initially IIRC.

Ok. Thanks. I will check for it.

> 
> > > > I will be submitting a patch to enhance the existing pinctrl support for 
> > > > spi omap2 shortly which does above work.
> 
> > > How soon is shortly?
> 
> > Since I am adding this Pinctrl PM mode support to many other drivers (i2c, 
> > cpsw, da8xx-fb, hsmmc, ti-pwm, usb ...), I would say Shortly = 1 week - 10 days.
> 
> Well, I guess I'll keep the patch for now and drop it when you send out
> the PM code.

Fair enough.

> 


Regards, 
Gururaja
