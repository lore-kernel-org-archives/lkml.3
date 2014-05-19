Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaESN6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:58:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:26910 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbaESN6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:58:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,867,1392192000"; 
   d="scan'208";a="541460105"
Message-ID: <1400507927.5510.4.camel@acox1-desk.ger.corp.intel.com>
Subject: Re: [Fwd: Re: [goldfish] genirq: Flags mismatch irq 4. 00000000
 (serial) vs. 00000080 (goldfish_pdev_bus)]
From: Alan Cox <alan@linux.intel.com>
To: jet.chen@intel.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 19 May 2014 14:58:47 +0100
In-Reply-To: <1400506648.5510.0.camel@acox1-desk.ger.corp.intel.com>
References: <1400506648.5510.0.camel@acox1-desk.ger.corp.intel.com>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 0day kernel testing robot got the below dmesg and the first bad commit is
> > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git staging-next
> > > commit 9b17aeec232a5f0a61ce3952c2e728a0eeddda8b

I don't believe this one is actually a bug. Or rather it's an annoyance
that was already present on the 32bit Goldfish and I don't see a way of
avoiding it.

Goldfish is an Android emulator not a PC, if you build a Goldfish kernel
it won't run on a PC and mixing the setup gives nonsense results.

I don't know of any way to reliably detect we are running on Goldfish.
Given that it's easy enough to fix up a bit so I'll see if I can find
any documented way to detect Goldfish.

Alan


