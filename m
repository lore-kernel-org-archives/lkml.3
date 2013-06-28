Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab3F1NOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:14:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:46183 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3F1NOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:14:46 -0400
Date: Fri, 28 Jun 2013 15:14:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Vrabel <david.vrabel@citrix.com>
cc: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCHv6 0/5] xen: maintain an accurate persistent clock in more
 cases
In-Reply-To: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com>
Message-ID: <alpine.DEB.2.02.1306281510180.4013@ionos.tec.linutronix.de>
References: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013, David Vrabel wrote:
> These series fixes the above limitations and depends on "x86: increase
> precision of x86_platform.get/set_wallclock()" which was previously
> posted.

So I'd like to merge that in the following way:

I pick up patches 1-3 and stick them into tip timers/for-xen and merge
that branch into timers/core. When picking up 1/6, I'll drop the xen
part of that, so timers/core will not hold any xen specific bits.

Then the xen folks can pull timers/for-xen and apply the xen specific
stuff on top.

Thanks,

	tglx

 
