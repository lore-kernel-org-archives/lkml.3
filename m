Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab3LST3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:29:11 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:33244 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3LST3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:29:09 -0500
Message-ID: <1387481345.5494.1.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Davidlohr Bueso <davidlohr@hp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, dvhart@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, paulmck@linux.vnet.ibm.com,
        efault@gmx.de, jeffm@suse.com, torvalds@linux-foundation.org,
        jason.low2@hp.com, Waiman.Long@hp.com, tom.vaden@hp.com,
        scott.norton@hp.com, aswin@hp.com
Date: Thu, 19 Dec 2013 11:29:05 -0800
In-Reply-To: <20131219192532.GB564@gmail.com>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
	 <1387478746-5436-5-git-send-email-davidlohr@hp.com>
	 <20131219192532.GB564@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 20:25 +0100, Ingo Molnar wrote:
> * Davidlohr Bueso <davidlohr@hp.com> wrote:
> 
> > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> > Signed-off-by: Jason Low <jason.low2@hp.com>
> 
> So, that's not a valid SOB sequence either, the person sending me a 
> patch should be the last person in the SOB chain 

Which is why I had it like that in the original version.

> - if you want to 
> credit them please add a Reviewed-by or add special credits to the 
> changelog.

I will change the tags and resend in a v4.

Thanks,
Davidlohr

