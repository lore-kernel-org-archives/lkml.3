Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbaDRNTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:19:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21676 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbaDRNTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:19:04 -0400
Date: Fri, 18 Apr 2014 09:18:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Marcos Matsunaga <Marcos.Matsunaga@oracle.com>
Subject: Re: [PATCH v9 00/19] qspinlock: a 4-byte queue spinlock with PV
 support
Message-ID: <20140418131807.GD4010@phenom.dumpdata.com>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
 <20140417172246.GA9849@localhost.localdomain>
 <53508474.7010402@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53508474.7010402@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 09:48:36PM -0400, Waiman Long wrote:
> On 04/17/2014 01:23 PM, Konrad Rzeszutek Wilk wrote:
> >On Thu, Apr 17, 2014 at 11:03:52AM -0400, Waiman Long wrote:
> >>v8->v9:
> >>   - Integrate PeterZ's version of the queue spinlock patch with some
> >>     modification:
> >>     http://lkml.kernel.org/r/20140310154236.038181843@infradead.org
> >>   - Break the more complex patches into smaller ones to ease review effort.
> >>   - Fix a racing condition in the PV qspinlock code.
> >I am not seeing anything mentioning that the overcommit scenario
> >for KVM and Xen had been fixed. Or was the 'racing condition' said
> >issue?
> >
> >Thanks.
> 
> The hanging is caused by a racing condition which should be fixed in
> the v9 patch. Please let me know if you are still seeing it.

OK, is there a git tree with these patches to easily slurp them up?


Thanks!
> 
> -Longman
