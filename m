Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161262AbaDPVri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:47:38 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43953 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596AbaDPVrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:47:35 -0400
Date: Wed, 16 Apr 2014 14:47:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <pranith@gatech.edu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] kernel/torture.c: unmark torture_init_* as __inline
Message-ID: <20140416214730.GC4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <534EDBF4.6030702@gatech.edu>
 <534EDCC7.1040701@gatech.edu>
 <20140416204433.GZ4496@linux.vnet.ibm.com>
 <CAJhHMCD9rcyp07pWn7L1ojpv57ducYezCh-g25J3LfvuubJ_gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCD9rcyp07pWn7L1ojpv57ducYezCh-g25J3LfvuubJ_gQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041621-6688-0000-0000-00000125F2B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 05:34:26PM -0400, Pranith Kumar wrote:
> On Wed, Apr 16, 2014 at 4:44 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > Good catch, queued for 3.16!  I missed it because of my habit of building
> > the torture tests directly into the kernel rather than loading them
> > as modules.  So thank you both for the patch and for your testing efforts!
> 
> You are welcome!
> 
> > Just out of curiosity, what are you thinking of using this for?
> >
> 
> I am exploring RCU in my research, looking for ways to apply the ideas
> to GPGPU and was studying the source code in the kernel. I will
> hopefully be using this in the future.

Nice!  Please let me know how it goes!

> (I should probably stick to userspace rcu :)

It might be better suited to your needs, but by all means continue
testing and inspecting the Linux-kernel RCU!  It does feel good to
get rid of some of the cruft, and I probably would never spot it.

Thank you again!

							Thanx, Paul

