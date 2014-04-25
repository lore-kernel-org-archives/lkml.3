Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaDYCta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 22:49:30 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39203 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaDYCt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 22:49:28 -0400
Date: Thu, 24 Apr 2014 19:49:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, linux-next@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: mmotm 2014-04-24-13-07 uploaded
Message-ID: <20140425024924.GR4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140424200837.727695A407C@corp2gmr1-2.hot.corp.google.com>
 <535992DD.3060808@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535992DD.3060808@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042502-8236-0000-0000-000001CA7683
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 03:40:29PM -0700, Randy Dunlap wrote:
> On 04/24/14 13:08, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2014-04-24-13-07 has been uploaded to
> > 
> >    http://www.ozlabs.org/~akpm/mmotm/
> > 
> > mmotm-readme.txt says
> > 
> > README for mm-of-the-moment:
> > 
> > http://www.ozlabs.org/~akpm/mmotm/
> > 
> > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > more than once a week.
> > 
> > You will need quilt to apply these patches to the latest Linus release (3.x
> > or 3.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> > http://ozlabs.org/~akpm/mmotm/series
> > 
> 
> uml on x86_64 defconfig:
> 
> drivers/built-in.o: In function `__handle_sysrq':
> drivers/tty/sysrq.c:514: undefined reference to `rcu_sysrq_start'
> drivers/tty/sysrq.c:558: undefined reference to `rcu_sysrq_end'

Hmmm...  Looks like Rik's patch needs declarations in rcupdate.h.
Not sure how I missed that...  :-/

							Thanx, Paul

