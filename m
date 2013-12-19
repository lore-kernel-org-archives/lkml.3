Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab3LSTZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:25:37 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:64699 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab3LSTZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:25:36 -0500
Date: Thu, 19 Dec 2013 20:25:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, dvhart@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, paulmck@linux.vnet.ibm.com,
        efault@gmx.de, jeffm@suse.com, torvalds@linux-foundation.org,
        jason.low2@hp.com, Waiman.Long@hp.com, tom.vaden@hp.com,
        scott.norton@hp.com, aswin@hp.com
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
Message-ID: <20131219192532.GB564@gmail.com>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
 <1387478746-5436-5-git-send-email-davidlohr@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387478746-5436-5-git-send-email-davidlohr@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Davidlohr Bueso <davidlohr@hp.com> wrote:

> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> Signed-off-by: Jason Low <jason.low2@hp.com>

So, that's not a valid SOB sequence either, the person sending me a 
patch should be the last person in the SOB chain - if you want to 
credit them please add a Reviewed-by or add special credits to the 
changelog.

Thanks,

	Ingo
