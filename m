Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252AbaCQOIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 10:08:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61544 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbaCQOI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 10:08:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: DT update for 3.15 #1
Date: Mon, 17 Mar 2014 15:08:21 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
References: <1394705197-29992-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1394705197-29992-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201403171508.21419.arnd@arndb.de>
X-Provags-ID: V02:K0:mGSqNc/plnF3h9rLzqkeCE7/xtJF4+8rC2Qs6ktewzd
 8xrcIjnUEIi9xKLvorsVe4qPhCDhW6gFxejPMl58AxRL4ZG/1T
 vPcJP2zRfUu/zx4fLq+L+RMj0AEaa6ituHwuc+2xsok8vhQVj1
 kIKZ60Q3FIkcViilf1UlMEDYiTn7KGFU76jKqdHi7KAOdlkJal
 +Kn/d7m0H91sKjaBrEH+cLSaGM0KEESwfEXiaa5DADkQLG0cuW
 IqEikj2TOyzBZPIZzWy3kBBP8Ig7kvpTta6A9ILGRq1gkTFuif
 XW1N5m2Pn43jQd5baFQSmLMHAbVnJD5NAt5msZRtz2GYh/wz2u
 kGEH6t7wL+bBPeuiIllhqaLmFNpSnVySDuUXomEor
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2014, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> This is one request for AT91 DT update for 3.15. A lot of forgotten bits that
> are corrected here, and old DT properties that are removed, nothing really new.
> I think that the little modifications to the documentation can also go the
> arm-soc way: there is no fundamental change to the binding, only more coherence
> added.

Merged into next/dt branch, thanks!

	Arnd
