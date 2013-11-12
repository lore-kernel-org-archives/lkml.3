Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab3KLIcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:32:09 -0500
Received: from www.linutronix.de ([62.245.132.108]:45214 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3KLIbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:31:50 -0500
Date: Tue, 12 Nov 2013 09:31:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vinayak Kale <vkale@apm.com>
cc: Will Deacon <will.deacon@arm.com>, Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@apm.com" <patches@apm.com>, "jcm@redhat.com" <jcm@redhat.com>
Subject: Re: [PATCH 0/2] genirq: arm64: perf: support for percpu pmu
 interrupt
In-Reply-To: <CAPrCYkf60+9RJ2aJ5ep3-j+ThdniJQHnUj_8POrCr7X2veKRZQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1311120924390.30673@ionos.tec.linutronix.de>
References: <1383739658-10036-1-git-send-email-vkale@apm.com> <527D8A17.9020208@codeaurora.org> <20131111104432.GA28302@mudshark.cambridge.arm.com> <CAPrCYkf60+9RJ2aJ5ep3-j+ThdniJQHnUj_8POrCr7X2veKRZQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Nov 2013, Vinayak Kale wrote:
> On Mon, Nov 11, 2013 at 4:14 PM, Will Deacon <will.deacon@arm.com> wrote:
> > cleaner from a user perspective, I always get scared when I see
> > 'desc->status_use_accessors' since it tends to incur the wrath of tglx :)

Nah, if it uses accessors, then it's fine.

> > That said, I guess that should be fine in irqdesc.h (basically adding a new
> > accessor). Chris went missing after sending those initial patches, so
> > perhaps Vinayak could look at resurrecting those?
> >
> Okay, in next patch revision I will use that approach.

Works for me.

Thanks,

	tglx
 
