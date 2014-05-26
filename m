Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaEZLPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 07:15:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:43960 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbaEZLPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 07:15:33 -0400
Date: Mon, 26 May 2014 13:15:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: amirv@mellanox.com
cc: Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>, idos@mellanox.com,
        Yevgeny Petrilin <yevgenyp@mellanox.com>
Subject: Re: Extend irq_set_affinity_notifier() to use a call chain
In-Reply-To: <5381DEDC.8050204@gmail.com>
Message-ID: <alpine.DEB.2.02.1405261313570.21720@ionos.tec.linutronix.de>
References: <5381DEDC.8050204@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2014, Amir Vadai wrote:
> In order to do that, I need to add a new irq affinity notification
> callback (In addition to the existing cpu_rmap notification). For
> that I would like to extend irq_set_affinity_notifier() to have a
> notifier call-chain instead of a single notifier callback.

Why? "I would like" is a non argument.

Thanks,

	tglx
