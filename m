Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaAMKFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:05:24 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:52560 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaAMKFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:05:20 -0500
Date: Mon, 13 Jan 2014 11:05:17 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Davidlohr Bueso <davidlohr@hp.com>, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, efault@gmx.de, jeffm@suse.com,
        torvalds@linux-foundation.org, jason.low2@hp.com, Waiman.Long@hp.com,
        tom.vaden@hp.com, scott.norton@hp.com, aswin@hp.com
Subject: Re: [PATCH v6 0/5] futex: Wakeup optimizations
Message-ID: <20140113100517.GA7332@gmail.com>
References: <1389569486-25487-1-git-send-email-davidlohr@hp.com>
 <alpine.DEB.2.02.1401131102410.4578@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401131102410.4578@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sun, 12 Jan 2014, Davidlohr Bueso wrote:
> 
> For the whole series:
> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Thanks Thomas, I'll pick them up into the locking tree.

	Ingo
