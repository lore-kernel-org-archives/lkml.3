Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbaBFSnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:43:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358AbaBFSnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:43:51 -0500
Date: Thu, 6 Feb 2014 19:43:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: NeilBrown <neilb@suse.de>, paulus@samba.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 45/51] md, raid5: Fix CPU hotplug callback registration
Message-ID: <20140206184323.GB31410@redhat.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205221244.19080.70910.stgit@srivatsabhat.in.ibm.com> <20140206121151.0cbdbaa1@notabene.brown> <52F35E62.2060003@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F35E62.2060003@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06, Srivatsa S. Bhat wrote:
>
> On 02/06/2014 06:41 AM, NeilBrown wrote:
> > Shall I wait for a signed-of-by from Oleg, then queue it through my md tree?
> >
>
> Sure, that sounds great, since this patch doesn't have any dependency.
> Thanks a lot!
>
> Oleg, it would be great if you could kindly add your S-O-B to this patch.
> Thanks!

Thanks Neil and Srivatsa,

Sure, feel free to add

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

