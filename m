Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaEPXDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 19:03:01 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:54090 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755508AbaEPXC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 19:02:59 -0400
Date: Fri, 16 May 2014 18:02:55 -0500 (CDT)
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
In-Reply-To: <CAOS58YOTAEGP+=sgSGVDLW+X11QZ_s9jTyRwmpeUD9JQiWbjQQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1405161802020.3336@gentwo.org>
References: <1400257015-28222-1-git-send-email-fweisbec@gmail.com> <1400257015-28222-4-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.10.1405161250350.492@gentwo.org> <20140516183500.GI5379@htj.dyndns.org> <alpine.DEB.2.10.1405161350360.1681@gentwo.org>
 <20140516190042.GJ5379@htj.dyndns.org> <alpine.DEB.2.10.1405161431590.2126@gentwo.org> <CAOS58YPwkWQCtuE=sUReBzi+3ygvsawEovV-nfWLK2f3GDn9Kg@mail.gmail.com> <CAOS58YOTAEGP+=sgSGVDLW+X11QZ_s9jTyRwmpeUD9JQiWbjQQ@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014, Tejun Heo wrote:

>
> So, the thing is sysfs has been collecting everything under
> /sys/devices because other top level directories added complexity
> while missing out on basic event mechanism. If you look at other

Make the uevent stuff work on all of sysfs?

