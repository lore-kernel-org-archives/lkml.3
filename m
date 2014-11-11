Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaKKLgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:36:15 -0500
Received: from www.linutronix.de ([62.245.132.108]:35292 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaKKLgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:36:11 -0500
Date: Tue, 11 Nov 2014 12:35:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jason Cooper <jason@lakedaemon.net>
cc: Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, arm@kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srv_heupstream@mediatek.com,
        yingjoe.chen@gmail.com, hc.yen@mediatek.com, eddie.huang@mediatek.com,
        nathan.chung@mediatek.com, yh.chen@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 0/6] ARM: mediatek: Add support for interrupt
 polarity
In-Reply-To: <20141109053820.GU3698@titan.lakedaemon.net>
Message-ID: <alpine.DEB.2.11.1411111234220.3935@nanos>
References: <1414576824-16143-1-git-send-email-yingjoe.chen@mediatek.com> <20141109053820.GU3698@titan.lakedaemon.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2014, Jason Cooper wrote:

> Thomas, Marc,
> 
> Could I get Acks for the core changes and gic changes when you have
> a moment?

this depends on the core irqdomain changes which are not yet in
tip. I'm waiting for Jiangs latest iteration and Marcs feedback on
those.

Thanks,

	tglx
