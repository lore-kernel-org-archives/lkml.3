Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbaJ2HrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 03:47:00 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:65256 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbaJ2Hq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 03:46:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: f.fainelli@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH 07/11] irqchip: brcmstb-l2: Use irq_reg_* accessors
Date: Wed, 29 Oct 2014 08:46:46 +0100
Message-ID: <4282257.X5Vskr4CUy@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414555138-6500-7-git-send-email-cernekee@gmail.com>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <1414555138-6500-7-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:x66CgA/gIhMve7bKeYJA7ynZM23zOSJrtMUjulodbag
 /qZkLviO27Ncl5HbB2CR5nFrN7HoGmTW0Kg4Pd8LWvg2xCqOIi
 S2ziwCEjzg31w1X4MNBTlQs6vm211UR5amEoDMUGFqnMrlFo/k
 x0NZvkzLBAJS4kikoMbhGRqdHIyk3+Og0AVZmWcRfq2Tej2bsE
 EnbHRA3PoCsVH0Z18u7JSlp0YzQaIkewNQ3S07WCG1L0IEbn4q
 MwDerOc3XWHO3THmiUQLGd6FRB4L6h2PPHftllE6ZG+K+QSZn7
 wwlWSfUIG2ubU6d35oDoAEqsmZb3/j82zLtPYuppvz6eeOMNg/
 oRCISJUumAI5mFnpMClk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 20:58:54 Kevin Cernekee wrote:
> This change was just made on bcm7120-l2, so let's keep things consistent
> between the two drivers.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
