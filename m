Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215AbaBWGLJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 01:11:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59984 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaBWGLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 01:11:07 -0500
Message-ID: <1393135859.30960.8.camel@marge.simpson.net>
Subject: Re: It BOOTS! 3.13.5 that is.
From: Mike Galbraith <bitbucket@online.de>
To: Gene Heskett <gheskett@wdtv.com>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 23 Feb 2014 07:10:59 +0100
In-Reply-To: <201402230018.34029.gheskett@wdtv.com>
References: <201402222022.20370.gheskett@wdtv.com>
	 <201402222300.35472.gheskett@wdtv.com>
	 <CAKb7Uvj1mKeS=gR6xBQnz4J1Ft3kKSftrdCRF7md+CabGy--4g@mail.gmail.com>
	 <201402230018.34029.gheskett@wdtv.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:spQ5oTDh8gd6Zifcww9QyLM5jk8PicK5pBZfxekNnoh
 fNqxhrqzEjWxlR8qyZ0T49F5TF6wlzYvwj/UKVd6Y4gCxl1WxE
 xG8Fk9FVobxqocn2DroIHooc93UgEMO0q6vAU6qluQGW/r1+OG
 LM8d35R/TtNz69hTPMnZRmDDDy7gtCp0+f2SLco5sOBTeGDR9o
 rnLueTozLihgWHQuKsZrCI4UNd3fW4q98TRL1sCI7vYec8pl7Q
 QMMetqp/lyErTFN6qmi6jj6Yl6Fj0OMcmABp1qEMuhj/iR4u8c
 n0NMj52Qyoqf1Z2PdJiMbdRJ8evSuDJYuNdzY6B4fX2Xpw/fN8
 0/qkzTuHACA4IlCM1LBd2YAqa08kbl+rT2R0rBwoXM6v2K9gar
 LW+ffuhhTkzxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-23 at 00:18 -0500, Gene Heskett wrote: 
> On Saturday 22 February 2014, Ilia Mirkin wrote:

> Sorry, no such beast As VIDEO_CX88.
> 
> Now that tells me something in the VIDEO dept isn't set, but what?

Beast radar:
find drivers -name Kconfig -exec grep -C5 VIDEO_CX88 {} \;

Blip:
config VIDEO_CX88
        tristate "Conexant 2388x (bt878 successor) support"
        depends on VIDEO_DEV && PCI && I2C && RC_CORE  <=== IFF signature
        select I2C_ALGOBIT
        select VIDEO_BTCX
        select VIDEOBUF_DMA_SG
--
          TV cards.

          To compile this driver as a module, choose M here: the
          module will be called cx8800

