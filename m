Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbaK1PQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:16:28 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:51436 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaK1PQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:16:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: cleanup for 3.19 #3
Date: Fri, 28 Nov 2014 16:15:52 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
References: <1417014866-14623-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1417014866-14623-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201411281615.53204.arnd@arndb.de>
X-Provags-ID: V02:K0:gDa9JaG/mB4Sz+r+Ypz8iG/2865KC8rEe/gHRRA45ED
 h/X0zTjCmf+qMIwccqvy/X6KkIMbDZJFievcfFF2NG1pNpP0Vy
 si9VzVIIS1zqPIjQlXhjPHHGsIJo2nDf53StAvONj1oJK8yJvz
 j8p9t4VOxxokWs+hRm2SHGxS9qZdQsNz4WSJ5psJ0JxCE866+3
 TlbLojRoLonQPlyR5kfg1yuOnac3yQKlKb3Q1A62qC7M4XPwx9
 ON0UP7374ClnywnYnvwVTrxGCt43ww2u89joeB2hqH73wV+n2Z
 UruOG0GFTDqZbwPN3qeqH0LNySGhz+DvftZRjPWJsxtjpNUBG3
 KBQ+KJ/6IN2cfbWCHIjbf5N+4BlwYAEcj+ZfLRaRo
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 November 2014, Nicolas Ferre wrote:
> ----------------------------------------------------------------
> Third batch of cleanup/SoC for 3.19:
> - fixes following legacy board removal
> - removal of legacy board support for at91sam9263, at91sam9260/at91sam9g20
>   and at91sam9261/at91sam9g10 SoCs families. Please use DT now.
> - removal of some now useless Kconfig options
> 

Pull into next/cleanup, thanks!

	Arnd
