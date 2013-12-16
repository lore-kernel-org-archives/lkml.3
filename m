Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab3LPE7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 23:59:14 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40273 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab3LPE7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 23:59:10 -0500
Date: Sun, 15 Dec 2013 20:59:00 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: msalter@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rth@twiddle.net, linux-alpha@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, tony.luck@intel.com,
        fenghua.yu@intel.com, linux-ia64@vger.kernel.org, ralf@linux-mips.org,
        linux-mips@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, lethal@linux-sh.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        gxt@mprc.pku.edu.cn, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org
Subject: Re: [PATCH 10/10] Kconfig: cleanup SERIO_I8042 dependencies
Message-ID: <20131216045859.GA4322@core.coreip.homeip.net>
References: <52ACA43F.2040402@zytor.com>
 <20131215103657.GB20197@core.coreip.homeip.net>
 <1387122626.1979.136.camel@deneb.redhat.com>
 <20131215.202725.1549146673897801643.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131215.202725.1549146673897801643.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 08:27:25PM -0500, David Miller wrote:
> From: Mark Salter <msalter@redhat.com>
> Date: Sun, 15 Dec 2013 10:50:26 -0500
> 
> > On Sun, 2013-12-15 at 02:36 -0800, Dmitry Torokhov wrote:
> >> How are we going to merge this? In bulk through input tree or peacemeal
> >> through all arches first?
> >
> > They should all go together to eliminate the chance of bisect breakage.
> > Either the input tree or maybe akpm tree.
> 
> This sounds good to me.

OK, then I'll pick it up once I collect more acks from the arch
maintainers.

-- 
Dmitry
