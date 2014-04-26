Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaDZJf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 05:35:26 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:54960 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaDZJfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 05:35:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [GIT PULL] at91: fixes for 3.15 #1
Date: Sat, 26 Apr 2014 11:32:14 +0200
Message-ID: <4230576.PqgF2ezODp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <535B0A00.9080808@atmel.com>
References: <1397857958-11283-1-git-send-email-nicolas.ferre@atmel.com> <535B0A00.9080808@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:mXNFtYI+Bfx9iF/R2mGZDUI0974pXZrkYeuw0yvLN9O
 8/heKLav00L/GO5PuYfDdO+HfwnsFeQgDDLJpL6VY5aUZDgQKu
 ZQCgayfeADFisbyIlHJCy8L/CBF9qhc+ES4roSBsBXBP4LJmJu
 tEqL8a4tF8Ftsyc6mTD1kjmFB5SEf81t5Ruei6I7F6Mc0OcDH5
 oV8uhj83tjgskQeJcPizs1NZGcqnItCkMdB0wyqql3eq6Ny4iD
 EMsEHLF41FsN7WhpqooyUzz772xr+LTLoeiVxioxhOwz2yNyk7
 ySgkPrz8xy5js8e1AribTzDBOyxM3az0WwSJieCI/5y8kA0TWa
 5IovwSqpi3zmPWndu0TI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 April 2014 18:21:04 Nicolas Ferre wrote:
> On 18/04/2014 14:52, Nicolas Ferre :
> > Arnd, Olof, Kevin,
> > 
> > Two little fixes for AT91. The one that moves the dt-bindings include
> > directory is pretty interesting as, with Exynos, AT91 was the only one
> > to use this "clk" directory.
> > 
> > Thanks, best regards,
> > 
> > The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:
> > 
> >   Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)
> > 
> > are available in the git repository at:
> > 
> >   git://github.com/at91linux/linux-at91.git tags/at91-fixes
> 
> Arnd,
> 
> It seems that this material has not been integrated in today's arm-soc
> pull-request to Linus.
> 
> Was it too late for this batch?

No, it was my mistake that it got missed. Sorry about that, I've applied
it now and will send it next time.
	
	Arnd
