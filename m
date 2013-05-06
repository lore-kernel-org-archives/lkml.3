Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3EFNZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 09:25:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:51962 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab3EFNZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 09:25:43 -0400
Date: Mon, 6 May 2013 15:25:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Gerlando Falauto <gerlando.falauto@keymile.com>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC patch 7/8] fixup 1/2: genirq: generic chip: Add linear irq
 domain support
In-Reply-To: <1367843533-7117-1-git-send-email-sebastian.hesselbarth@gmail.com>
Message-ID: <alpine.LFD.2.02.1305061524520.3095@ionos>
References: <20130503214629.810207749@linutronix.de> <1367843533-7117-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 May 2013, Sebastian Hesselbarth wrote:

> irq_domain_chip_generic is allocating and indexing irq_chip_generic
> itself. However, the size of irq_chip_generic varies with number of
> irq_chip_types. This fixup moves irq_chip_generic helt by
> irq_domain_chip_generic to array of ptr and fixes the pointer arith
> used by irq_alloc_domain_generic_chip.

Thanks. I folded it in.
