Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3F1UlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:41:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:48270 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab3F1UlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:41:06 -0400
Date: Fri, 28 Jun 2013 22:41:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Vrabel <david.vrabel@citrix.com>
cc: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 5/5] x86/xen: sync the CMOS RTC as well as the Xen
 wallclock
In-Reply-To: <51CDBF05.5070502@citrix.com>
Message-ID: <alpine.DEB.2.02.1306282240010.4013@ionos.tec.linutronix.de>
References: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com> <1372329348-20841-6-git-send-email-david.vrabel@citrix.com> <alpine.DEB.2.02.1306281727240.4013@ionos.tec.linutronix.de> <51CDB0A1.6080409@citrix.com> <alpine.DEB.2.02.1306281805430.4013@ionos.tec.linutronix.de>
 <51CDBF05.5070502@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jun 2013, David Vrabel wrote:
> On 28/06/13 17:09, Thomas Gleixner wrote:
> > Yep. I'll pick that up.
> 
> If it helps, I've made this change as well as splitting the xen part of
> the hrtimers patch out into a separate commit.

Fun. I already have that same split in my pending queue :)

Thanks,

	tglx
