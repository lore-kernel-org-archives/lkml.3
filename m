Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab3H0ThL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:37:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51564 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3H0ThH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:37:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [RFC v1 0/5] ARM: Initial support for Marvell Armada 1500
Date: Tue, 27 Aug 2013 21:38:53 +0200
Message-ID: <2660767.3xDXT08nY0@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.10.95; x86_64; ; )
In-Reply-To: <20130827161958.5e71890d@skate>
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130827161958.5e71890d@skate>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:LESZmKWcy/gw8blFrpTyWDbi31CirjPhnhR6zrCxXiF
 ha5QeQiL86iX1J/zLNxCNQkrT+fqSdB9EYFxnYn4i0PSAJUbfx
 pk2N/VkoAjh6frdTO/823X+lsYRMsmXbe1AQExzG5qeUeITbmk
 260qTKF/qNFdVNZ/CEubbLhndkd7jrCzH7YtvvjoB+A7mgd/zs
 GOrVKHI4uPoTxveyjMjBPE56lGv4/y/cF/VliEKZ+A8o9pcG+x
 mnSGQkHQmIZHkVtQbPRZ57nIdAgLA8LKbTFMl8BnATvmcJ9yv8
 5ejEr4aVLDuy0omIS4nKwRGyXQ+RAM1FT69mdLWzKXMsVth3oc
 rGdPbpfsQ3i0RksChYxg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 August 2013 16:19:58 Thomas Petazzoni wrote:
> 
> Also, to help us understand the organization of the family of SOCs, I
> asked a few informations to Marvell, and here is what I could collect:
> 
> """
> BGxname         CPU core        codename        L2 cache controller     internal name
> BG2             PJ4B            Armada1500      Tauros3                 MV88DE3100
> BG2-CT          Cortex-A9       N/A             PL310                   N/A
> BG3             Cortex-A15      N/A             CA15 integrated         N/A
> """

My guess is that BG2-CT is Armada1500-mini aka MV88DE3005, i.e. the chip
used in the chromecast.
At least that is what gets used in the chromecast kernel sources, but it's
also possible that there are UP and SMP versions of BG2-CT and that
DE3005 is only the former.

	Arnd
