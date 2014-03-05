Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbaCEP4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:56:06 -0500
Received: from one.firstfloor.org ([193.170.194.197]:60494 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbaCEP4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 10:56:04 -0500
Date: Wed, 5 Mar 2014 16:56:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Khalid Aziz <khalid.aziz@oracle.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        peterz@infradead.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
Message-ID: <20140305155601.GF22728@two.firstfloor.org>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
 <531641A8.40306@zytor.com>
 <53164824.3000704@oracle.com>
 <20140304222356.41c55bbc@alan.etchedpixels.co.uk>
 <5316574F.6040105@oracle.com>
 <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de>
 <8738ix5uyk.fsf@tassilo.jf.intel.com>
 <20140305145420.GA30173@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305145420.GA30173@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 03:54:20PM +0100, Oleg Nesterov wrote:
> On 03/04, Andi Kleen wrote:
> >
> > Anything else?
> 
> Well, we have yield_to(). Perhaps sys_yield_to(lock_owner) can help.
> Or perhaps sys_futex() can do this if it knows the owner. Don't ask
> me what exactly I mean though ;)

You mean yield_to() would extend the time slice?

That would be the same as the mmap page, just with a syscall right?

-andi

-- 
ak@linux.intel.com -- Speaking for myself only.
