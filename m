Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaK0QuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:50:03 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:55548 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaK0Qt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:49:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH 00/11] ARM: at91: remove !DT support for at91rm9200
Date: Thu, 27 Nov 2014 17:49:50 +0100
Message-ID: <3550407.q87bWB4Jdt@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <cover.1417103399.git.nicolas.ferre@atmel.com>
References: <cover.1417103399.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ufXN9QLZUR98ueiLWfnVmMPm8CDnNpUUxIaorLuCLqm
 woKqwn/Ki426beKVi89QjggrP4HGJp1uyDSZlV8/HfzoHOhFxS
 tW3aT5Z7a5G/IhmLtWpLW0e95H9Dfk1gX6Vu94eAM/R1mhUWD5
 /3xqJUXvqwCf8vpE1KEyH2KLAp3f29kEB6c1lTKCA0uPujFwmo
 CVN/gTYsxQKov8TmOUFMNZH/Yh+Wl1m9KcM8FfNWEOXNchgVGC
 Eua/5orrL+0cI/JoHHwTtLA2MlrHItC7Jyxny/QhQ4CBL/0n1p
 fAVYdFWY4AbRMGo9REonZ81lM1LPI9PNdwXVrF0TszKo5+M4FW
 Vtty9//bf9eCHZAIm5ng=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 17:06:28 Nicolas Ferre wrote:
> This is the last series of patches that removes the non-Device-Tree board
> support for older Atmel SoCs.
> Again, for the record, it was announced here
> https://lkml.org/lkml/2014/9/10/293 ([ANNOUNCE] ARM: at91: removal of board
> files) two months ago.
> Several files beyond at91rm9200 are touched this time as I tried to remove the
> biggest parts that were related to !DT SoC initializations. More cleanup is
> certainly needed to remove dead code.
> 
> The diffstat is also pretty big as a lot of at91rm9200 boards were remaining.
> 

Awesome stuff!

Two questions:

- is anything holding this up from getting merged in 3.19?

- Are there any remaining issues that keep us from using multiplatform?
  I know you all have been working on those a lot, but I haven't
  checked what is still missing.

	Arnd
