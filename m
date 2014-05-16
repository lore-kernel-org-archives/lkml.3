Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992514AbaEPTcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:32:42 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:58438 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992438AbaEPTcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:32:41 -0400
Date: Fri, 16 May 2014 14:32:38 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/5] workqueue: Create low-level unbound workqueues
 cpumask
In-Reply-To: <20140516190042.GJ5379@htj.dyndns.org>
Message-ID: <alpine.DEB.2.10.1405161431590.2126@gentwo.org>
References: <1400257015-28222-1-git-send-email-fweisbec@gmail.com> <1400257015-28222-4-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.10.1405161250350.492@gentwo.org> <20140516183500.GI5379@htj.dyndns.org> <alpine.DEB.2.10.1405161350360.1681@gentwo.org>
 <20140516190042.GJ5379@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014, Tejun Heo wrote:

> > Could we fix that? A workqueue is not a device but more a kernel setting.
> >
> > /sys/kernel/workqueue/.... ?
>
> Right, that could have been more in line with slab files.  It's
> already too late tho.  This has been exposed for quite a while now.
> Urgh...

It sets a bad precedent. So move to /sys/kernel/workqueue and lets have a
symlink that goes back?

