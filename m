Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab3BLK16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:27:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33948 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab3BLK14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:27:56 -0500
Message-ID: <1360664874.4485.18.camel@laptop>
Subject: Re: [patch v4 08/18] Revert "sched: Introduce temporary
 FAIR_GROUP_SCHED dependency for load-tracking"
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Date: Tue, 12 Feb 2013 11:27:54 +0100
In-Reply-To: <1358996820-23036-9-git-send-email-alex.shi@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
	 <1358996820-23036-9-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
> Remove CONFIG_FAIR_GROUP_SCHED that covers the runnable info, then
> we can use runnable load variables.
> 
It would be nice if we could quantify the performance hit of doing so.
Haven't yet looked at later patches to see if we remove anything to
off-set this.

