Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbaEPRwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:52:30 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:55048 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756949AbaEPRw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:52:28 -0400
Date: Fri, 16 May 2014 12:52:26 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/5] workqueue: Create low-level unbound workqueues
 cpumask
In-Reply-To: <1400257015-28222-4-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.10.1405161250350.492@gentwo.org>
References: <1400257015-28222-1-git-send-email-fweisbec@gmail.com> <1400257015-28222-4-git-send-email-fweisbec@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014, Frederic Weisbecker wrote:

> It works on a lower-level than the per WQ_SYSFS workqueues cpumask files
> such that the effective cpumask applied for a given unbound workqueue is
> the intersection of /sys/devices/virtual/workqueue/$WORKQUEUE/cpumask and
> the new /sys/devices/virtual/workqueue/cpumask_unbounds file.

Why is there "virtual" directory in the path? Workqueues are "virtual"
devices?

