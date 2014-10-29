Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbaJ2Hql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 03:46:41 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:65532 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbaJ2Hqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 03:46:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: f.fainelli@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH 06/11] irqchip: bcm7120-l2: Use irq_reg_* accessors
Date: Wed, 29 Oct 2014 08:46:27 +0100
Message-ID: <1863628.skWLaDFD15@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414555138-6500-6-git-send-email-cernekee@gmail.com>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <1414555138-6500-6-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:VK+AReuOC0/93uxhBMUn5lMvgS1iyW48utrMgduPnWt
 sWiBLM08etgVHXZGFw24Vehlj3pDWGPBcyqwg7q3mdQYsFn8hW
 1lBQjmOjErIRyL4yKupEondTeCy+YRMF021uDF1OXcBaE/a6Da
 roFHvhyTWR5nuIMtrhEDKE/XKRwMPJGIJFF2Kkpv1vVmxEsSSQ
 dMFeKQbVMNt+y1oaGve1f7XQoRPz6NHjniP4pPgfgaOpHjUuOB
 Iyf5N9prCc1uLV0qqc0q8LryKkbAUBAMFxYUZAMPvDsUfObnAY
 wGU8skbG0cun3NazsceWgwaTPJr+Pj/IUa/thM0SO7ObY8UUlT
 cu1L1w/NrHS0Yo1Q1M3U=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 20:58:53 Kevin Cernekee wrote:
> This keeps things consistent between the "core" bcm7120-l2 driver and the
> helpers in generic-chip.c.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> ---
> 

Ah, you did. Nevermind my comment to patch 5 then ;-)

Acked-by: Arnd Bergmann <arnd@arndb.de>
