Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbaBDURh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:17:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:49119 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbaBDURd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:17:33 -0500
Date: Tue, 4 Feb 2014 21:17:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
cc: santosh.shilimkar@ti.com, rob@landley.net, linux@arm.linux.org.uk,
        galak@codeaurora.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        daniel.lezcano@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, grygorii.strashko@ti.com
Subject: Re: [PATCH v4 1/3] clocksource: timer-keystone: introduce clocksource
 driver for Keystone
In-Reply-To: <52F11B5C.40407@ti.com>
Message-ID: <alpine.DEB.2.02.1402042113270.24986@ionos.tec.linutronix.de>
References: <1391513453-21140-1-git-send-email-ivan.khoronzhuk@ti.com> <1391513453-21140-2-git-send-email-ivan.khoronzhuk@ti.com> <alpine.DEB.2.02.1402041715220.24986@ionos.tec.linutronix.de> <52F11B5C.40407@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014, Ivan Khoronzhuk wrote:

Please do not top post.

> It was so in v1. But it was decided to use explicit memory barriers,
> because we're always sure the memory barriers are there and that
> they're properly documented. Also in this case I don't need to add
> keystone readl/writel relaxed function variants and to use mixed calls of
> writel/writel_relaxed functions.
> 
> See:
> http://www.spinics.net/lists/arm-kernel/msg294941.html

Fair enough, but we want a proper explanation for explicit barriers in
the code and not in some random discussion of patch version X on some
random mailing list.

Aside of that it should be iowmb(), but I might miss something ...

Thanks,

	tglx

