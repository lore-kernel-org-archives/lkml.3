Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161329AbaJ3VqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 17:46:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161019AbaJ3VqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 17:46:24 -0400
Date: Thu, 30 Oct 2014 21:54:34 +0000
From: Alexander Gordeev <agordeev@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: Remove redundant rcu_is_cpu_rrupt_from_idle()
 function
Message-ID: <20141030215433.GA18126@agordeev.usersys.redhat.com>
References: <1414580827-19545-1-git-send-email-agordeev@redhat.com>
 <20141029124728.GL5718@linux.vnet.ibm.com>
 <20141029134519.GC30198@agordeev.usersys.redhat.com>
 <20141029143439.GN5718@linux.vnet.ibm.com>
 <20141029151622.GD30198@agordeev.usersys.redhat.com>
 <20141029154615.GR5718@linux.vnet.ibm.com>
 <20141029210916.GB13273@agordeev.usersys.redhat.com>
 <20141030000524.GG5718@linux.vnet.ibm.com>
 <20141030175435.GC13273@agordeev.usersys.redhat.com>
 <20141030204318.GR5718@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030204318.GR5718@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 01:43:18PM -0700, Paul E. McKenney wrote:
> > > Have you done any testing of this change?
> > 
> > Just booted to a unicore kernel and dd'ed 1G of /dev/sda to /dev/null.
> 
> OK, that is a start. Could I convince you to build a kernel?

I did build one with the patch I posted. Or you mean something else here?

> 							Thanx, Paul
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
