Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbaCKNVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:21:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbaCKNVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:21:08 -0400
Message-ID: <1394544016.5094.68.camel@deneb.redhat.com>
Subject: Re: [PATCH v6 0/6] mm: generic early_ioremap support
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Will Deacon <Will.Deacon@arm.com>, Dave Young <dyoung@redhat.com>,
        Rob Herring <robherring2@gmail.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>
Date: Tue, 11 Mar 2014 09:20:16 -0400
In-Reply-To: <20140311120845.GG31104@arm.com>
References: <1394384444-23182-1-git-send-email-msalter@redhat.com>
	 <20140311120845.GG31104@arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 12:08 +0000, Catalin Marinas wrote:
> Mark,
> 
> On Sun, Mar 09, 2014 at 05:00:38PM +0000, Mark Salter wrote:
> > This patch series takes the common bits from the x86 early ioremap
> > implementation and creates a generic implementation which may be used
> > by other architectures. The early ioremap interfaces are intended for
> > situations where boot code needs to make temporary virtual mappings
> > before the normal ioremap interfaces are available. Typically, this
> > means before paging_init() has run.
> > 
> > These patches are layered on top of generic fixmap patches which
> > were pulled into upstream 3.14-rc kernels.
> > 
> > This is version 6 of the patch series. These patches fixmap patches
> > may be found at:
> > 
> >   git://github.com/mosalter/linux.git (early-ioremap-v6 branch)
> 
> Are there any acks still needed? I think the arch patches in this series
> have been acked, so I'm happy if hpa or someone else takes the whole
> series.

v6 added a documentation patch which is the only one without an ack.
I was going to give it a few days and then send a pull request
tomorrow (12-Mar). This being mm related, I thought the mmotm tree
may be the place for it, but hpa offered the tip tree and it really
doesn't matter to me which one it goes through.


