Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750933AbaAKW1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 17:27:45 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:36426 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaAKW1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 17:27:43 -0500
Date: Sat, 11 Jan 2014 14:27:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] rcu_dereference_check_fdtable fix/cleanups
Message-ID: <20140111222737.GE10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140107181258.GA29288@redhat.com>
 <20140108132852.GF10038@linux.vnet.ibm.com>
 <20140108151918.GA5156@redhat.com>
 <20140109011650.GI10038@linux.vnet.ibm.com>
 <20140110153459.GA31491@redhat.com>
 <20140111063438.GY10038@linux.vnet.ibm.com>
 <20140111181908.GA7358@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140111181908.GA7358@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011122-0928-0000-0000-0000054ED457
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 07:19:08PM +0100, Oleg Nesterov wrote:
> On 01/10, Paul E. McKenney wrote:
> >
> > On Fri, Jan 10, 2014 at 04:34:59PM +0100, Oleg Nesterov wrote:
> > >
> > > doesn't this look much simpler than adding the "bool unshared" argument
> > > and changing the callers?
> >
> > I might be being too paranoid, but my concern with using rcu_lock_acquire()
> > and rcu_lock_release()
> 
> And I agree, I no longer suggest to use rcu_lock_acquire/release.
> 
> It seems that you misunderstood me, let me send v2 for review.

Ah, I did misunderstand you.  For both:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

							Thanx, Paul

