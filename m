Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3IXODq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 10:03:46 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:42829 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3IXODp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 10:03:45 -0400
Date: Tue, 24 Sep 2013 07:03:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
Subject: Re: False positive in checkpatch
Message-ID: <20130924140305.GZ9093@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130923225949.GA26278@linux.vnet.ibm.com>
 <1379996467.3575.67.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379996467.3575.67.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092414-0928-0000-0000-000001D6C611
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 09:21:07PM -0700, Joe Perches wrote:
> On Mon, 2013-09-23 at 15:59 -0700, Paul E. McKenney wrote:
> > Hello!
> > 
> > The checkpatch.pl script complains as follows:
> > 
> > ERROR: need consistent spacing around '*' (ctx:WxB)
> > #57: FILE: include/linux/rcupdate.h:564:
> > +		ACCESS_ONCE(p) = (typeof(*(v)) __force space *)(v); \
> > 
> > Of course, the two uses of '*' are doing different things, so it should
> > be OK for the spacing to be different.
> > 
> > Could you please fix this?
> > 
> > 							Thanx, Paul
> > 
> 
> Hi Paul.
> 
> Try this patch: https://lkml.org/lkml/2013/9/2/428
> 
> Andy?  Can you verify this suggested patch please?

That does it, thank you!  And it does look like this patch was directed
precisely at this patch.  ;-)

							Thanx, Paul

