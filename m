Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbaI3Vuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:50:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:33652 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbaI3Vut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:50:49 -0400
Date: Tue, 30 Sep 2014 23:50:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
cc: Jisheng Zhang <jszhang@marvell.com>, jason@lakedaemon.net,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] irqchip: dw-apb-ictl: always use use
 {readl|writel}_relaxed
In-Reply-To: <542AA157.8080908@gmail.com>
Message-ID: <alpine.DEB.2.11.1409302350080.4455@nanos>
References: <1411454100-6814-1-git-send-email-jszhang@marvell.com> <1411454100-6814-2-git-send-email-jszhang@marvell.com> <542AA157.8080908@gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Sebastian Hesselbarth wrote:

> On 09/23/2014 08:34 AM, Jisheng Zhang wrote:
> > relaxed version and non-relaxed version are mixed, this patch always
> > use the relaxed version to unify the memory access usage.
> > 
> > Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> 
> While I don't agree with the above reason (unification) for this

Then we want a proper changelog for it, really.

Thanks,

	tglx
