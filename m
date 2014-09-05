Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaIEVM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:12:57 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:49910 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaIEVMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:12:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL 1/4] at91: cleanup for 3.18 #1
Date: Fri, 5 Sep 2014 23:12:36 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
References: <1409593127-24049-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1409593127-24049-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201409052312.37052.arnd@arndb.de>
X-Provags-ID: V02:K0:M4vrSY6/xKVELeQwDELCdNklrpGvr25WvRxwhoSZOOR
 Yw56oVrchH8pgVE9uFuPkyfyXXken6sIs4X1585SjaJSO3gSh1
 ooXjWSh4q1YOJUfksmn1L7GTrn8R1/JkLZTm56tJ3QnJ8EAbcy
 jaeSE/0uiRavMbwxwXaE2bVonc/PFf5t0gDqXELNcJgZdz9pXB
 p+ZmB5mCiI3ouA717Tyl/I0AJ5MJcMb5HV2g/cC76LIgkxbS4l
 T11ybIcKm9Q3vJiJacIHWKNlFaAycNe6x909Tol2xbYT2r7sAC
 g5e+Gqa18sXbCIkuNaS4TVohKaYSb7EwFHaSe+A5M+JrW1O2rG
 JOqzIOfmwVjBUhx3vJYk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2014, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> Boris moved both of our AIC drivers to their new home: the drivers/irqchip
> directory taking advantage of the genirc framework. For DT-enabled SoCs, we can
> use these drivers (aic and aic5) as Jason merged them and they are
> available in 3.17 kernel.
> 

Pulled all four branches, thanks!

	Arnd
