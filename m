Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3CEMWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 07:22:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446Ab3CEMWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 07:22:23 -0500
Date: Tue, 5 Mar 2013 13:22:08 +0100
From: Anton Arapov <anton@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC PATCH v4 0/6] uprobes: return probe implementation
Message-ID: <20130305122208.GA13870@bandura.brq.redhat.com>
References: <1362407893-32505-1-git-send-email-anton@redhat.com>
 <20130305120417.GA25562@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130305120417.GA25562@gmail.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 01:04:17PM +0100, Ingo Molnar wrote:
> 
> * Anton Arapov <anton@redhat.com> wrote:
> 
> > Hello,
> > 
> >   RFC v4 uretprobes implementation. I'd be grateful for review.
> >   /* Oleg, this one is more quirky than previous, don't beat me. */
> 
> Please include a good high level description of the new feature in one of the 
> patches - preferably also stick it somewhere into Documentation/.

  Yes, I apologize, I did wait for someone's complaint to push myself to
write meaningful description.
 
thanks,
Anton

> Thanks,
> 
> 	Ingo
