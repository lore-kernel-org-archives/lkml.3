Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaJWVQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:16:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbaJWVQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:16:19 -0400
Date: Thu, 23 Oct 2014 23:13:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        htejun@gmail.com
Subject: Re: rcu_preempt detected stalls.
Message-ID: <20141023211304.GA10813@redhat.com>
References: <20141013173504.GA27955@redhat.com> <20141023183232.GW4977@linux.vnet.ibm.com> <20141023191319.GA5137@redhat.com> <20141023193807.GZ4977@linux.vnet.ibm.com> <20141023195337.GA7768@redhat.com> <20141023202443.GE4977@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023202443.GE4977@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23, Paul E. McKenney wrote:
>
> Your code, your rules.  ;-)

Heh, no. I do not trust my (perverted) taste, I never-never
argue with cosmetic issues ;)

Cough... and at the same time I have a small nit.

> But given this structure, why not use a for() loop replace the
> "goto retry" with an inverted condition and a "return error"?
> Maybe something like the following patch?

Thanks,

Acked-by: Oleg Nesterov <oleg@redhat.com>

