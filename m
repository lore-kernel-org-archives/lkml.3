Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaKXImA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 03:42:00 -0500
Received: from www.linutronix.de ([62.245.132.108]:36463 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaKXIl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 03:41:58 -0500
Date: Mon, 24 Nov 2014 09:41:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [LKP] [x86, irq, ACPI] 5fcb864ef90: -3.3%(vm-scalability.throughput)
 +12.9%(turbostat.%c0)
In-Reply-To: <20141124025141.GA7310@yliu-dev.sh.intel.com>
Message-ID: <alpine.DEB.2.11.1411240939340.6439@nanos>
References: <20141124025141.GA7310@yliu-dev.sh.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014, Yuanhan Liu wrote:
> 
> We noticed the below changes on(NOTE: I'm not sure the bisect is correct
> or not, here I report it out JFYI).
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit 5fcb864ef90df093d964171539c87ffa0ab49f0f ("x86, irq, ACPI: Implement interfaces to support ACPI based IOAPIC hot-removal")
> 

I really doubt that this commit has anything to do with the observed
behaviour change.

The code in question is only executed at boot time or when a IOAPIC is
physically hotplugged.

Thanks,

	tglx
