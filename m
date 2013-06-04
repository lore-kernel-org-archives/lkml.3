Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3FDVC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 17:02:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55350 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab3FDVC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 17:02:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Randy Dunlap <rdunlap@infradead.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: linux-next: Tree for Jun 4 (pch_phub.c)
Date: Tue, 4 Jun 2013 23:02:31 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <20130604174107.99848a1dbb2532ceffe993eb@canb.auug.org.au> <51AE4C54.6000709@infradead.org>
In-Reply-To: <51AE4C54.6000709@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306042302.31866.arnd@arndb.de>
X-Provags-ID: V02:K0://2uLkyOzrDSnZ3u+6s6Mh1Vbl0W4wsxwZMhFCTYj9W
 ssiP1Cmkp/kZZom+eOL0lUbmQiud16uE5VHXFZsWrozIXd5AyE
 1PGaj8IoGWPGny2Q8feVREZiEn3iGt0whs14G9qCnn0zjmHvxQ
 cVSyJf2aCGDsKTyZ104jLHVqOcbl8MIo9RZLB0UD1zlFd9KoDO
 ZBg4L9e3tyvPgu7e/NORaY/XYwKXqWXHRrfd5GbrBGRPPqAbwH
 ZCtbHB5/XxNYnOYSzHv+QgeEqFI10XHpv/YVMSu2WlHC60qsUu
 NmnWw3aY0G7K90AU0tx4hwrVgkmE/XpYcdWVEN++yQ8zr6t4vb
 eyc828997mG6rnv96X9U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013, Randy Dunlap wrote:
> 
> On 06/04/13 00:41, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20130603:
> > 
> 
> when CONFIG_NET is not enabled:
> 
> ERROR: "mac_pton" [drivers/misc/pch_phub.ko] undefined!

Andy Shevchenko just posted "[PATCH] net: core: move mac_pton() to
lib/net_utils.c" to fix this.

	Arnd
