Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaLDSNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:13:10 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:51115 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaLDSNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:13:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: cleanup for 3.19 #5
Date: Thu, 04 Dec 2014 19:12:31 +0100
Message-ID: <2294210.BDk2p4U6CY@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417715520-30412-1-git-send-email-nicolas.ferre@atmel.com>
References: <1417715520-30412-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:+EknFnZ45h7O5IEf2bKo2m46BhLeUMAS26P5CuxtfyGR5sXNN9q
 4U24zSIrdQ6ieoDXu5Ot71pnkLzGxhRjAEJ9zOBqlJddilHo6BjWh2zgr20+RJu8Ed6mMPz
 mbKvM8G0vyI+KIiC9g7NXwdqmR+HMkEJGOOYZisup2iKvomBAIrDvSypelZ/zOCdp0MibSH
 mcKz4CRKXf+JFSQiAKakg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2014 18:52:00 Nicolas Ferre wrote:
> This is the last "cleanup" pull-request for 3.19 on my side. Most of the work
> was done by Arnd actually 
> This simplifies even more the mach-at91 directory and remove a bunch of dead
> code. Arnd also wrote some more cleanup patches that I will keep for 3.20 as
> they modify files in a larger extent.
> 

Pulled into next/cleanup, thanks for organizing my draft patches properly!

	Arnd
