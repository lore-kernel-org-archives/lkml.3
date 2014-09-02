Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbaIBXW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 19:22:57 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:53542
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752365AbaIBXWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 19:22:55 -0400
Date: Tue, 2 Sep 2014 18:22:52 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dynticks: dynticks_idle is only modified locally use
 this_cpu ops
In-Reply-To: <20140902211517.GO5001@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1409021819500.5437@gentwo.org>
References: <alpine.DEB.2.11.1409021513490.26284@gentwo.org> <20140902203743.GL5001@linux.vnet.ibm.com> <alpine.DEB.2.11.1409021545370.32690@gentwo.org> <20140902211517.GO5001@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2014, Paul E. McKenney wrote:

> Yep, these two have been on my "when I am feeling insanely gutsy" list
> for quite some time.
>
> But I have to ask...  On x86, is a pair of mfence instructions really
> cheaper than an atomic increment?

Not sure why you would need an mfence instruction?

> > If the first patch I send gets merged then a lot of other this_cpu related
> > optimizations become possible regardless of the ones in the RFC.
>
> Yep, I am queuing that one.

Great.

> But could you please do future patches against the rcu/dev branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git?
> I had to hand-apply due to conflicts.  Please see below for my version,
> and please check to make sure that I didn't mess something up in the
> translation.

Looks ok. Will use the correct tree next time.


