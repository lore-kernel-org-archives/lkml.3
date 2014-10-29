Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbaJ2Hrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 03:47:45 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:49383 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbaJ2Hrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 03:47:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: f.fainelli@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH 08/11] irqchip: bcm7120-l2: Fix missing nibble in gc->unused mask
Date: Wed, 29 Oct 2014 08:47:29 +0100
Message-ID: <1877870.yMDyCEjdc0@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414555138-6500-8-git-send-email-cernekee@gmail.com>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <1414555138-6500-8-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QtHJgeqZlTaMz3c9iNjwQ5ul9CGpEMg9Spwin0ZZwP3
 YARE8Z9q/k487Zw8AujrPC6bobTafMuRVDiNmuvdEAS6F8zwiW
 XAucotgEd4lM4RVSATlzpqQEpOviJ1500nbCt9ZFMa6OuYwDtn
 lMEJckQDnuf4ruGykybWAV/L+eByDMxYTEzs5QS++8ZcYPdAC5
 EeRDaGCrTRABrVTF7l/c+7ATIhDzPHBy837zxDRnyaOGuj6LIP
 OrAVdHXxjoSDYyBm1YPL/mxI6qv1e5sezQ8Mxy+4BzSIv3WuEP
 vESUJxI6Uuubxg2TBhrTsDXbI2GFOocG3HpR2xNJjWDMAYbXYT
 zJXb4ZUDLV/Zs7QuGciA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 20:58:55 Kevin Cernekee wrote:
> This mask should have been 0xffff_ffff, not 0x0fff_ffff.
> 
> The change should not have an effect on current users (STB) because bits
> 31:27 are unused.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
