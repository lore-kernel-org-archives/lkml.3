Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbaD2RZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:25:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:42992 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624AbaD2RZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:25:49 -0400
Date: Tue, 29 Apr 2014 19:26:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jason Cooper <jason@lakedaemon.net>
cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] irqchip: mvebu: fixes for v3.15
In-Reply-To: <20140429125554.GH28159@titan.lakedaemon.net>
Message-ID: <alpine.DEB.2.02.1404291925210.6261@ionos.tec.linutronix.de>
References: <20140429125554.GH28159@titan.lakedaemon.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014, Jason Cooper wrote:
> Thomas Petazzoni (2):
>       irqchip: armada-370-xp: fix invalid cast of signed value into unsigned variable
>       irqchip: armada-370-xp: implement the ->check_device() msi_chip operation

Please make sure next time, that the sentence starts with an upper
case letter.

Pulled and pushed inot tip/irq/urgent
