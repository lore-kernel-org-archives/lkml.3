Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab3LSMzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:55:08 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:40694 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab3LSMzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:55:04 -0500
Date: Thu, 19 Dec 2013 13:54:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, dvhart@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, scott.norton@hp.com,
        tom.vaden@hp.com, aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com
Subject: Re: [PATCH v2 0/4] futex: Wakeup optimizations
Message-ID: <20131219125459.GB18527@gmail.com>
References: <1386063927-6545-1-git-send-email-davidlohr@hp.com>
 <1387380741.2797.27.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387380741.2797.27.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Davidlohr Bueso <davidlohr@hp.com> wrote:

> ping? 
> 
> If no one has any objections, could this patchset be picked up?

There were a couple of review comments that I don't see fully 
addressed, one of them involving the messy looking SOB chain, so a new 
version needs to be sent in any case.

Thanks,

	Ingo
