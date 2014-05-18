Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaERCvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 22:51:12 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:45068 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaERCvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 22:51:11 -0400
Date: Sat, 17 May 2014 22:51:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/5] workqueue: Create low-level unbound workqueues
 cpumask
Message-ID: <20140518025106.GA4545@htj.dyndns.org>
References: <alpine.DEB.2.10.1405161250350.492@gentwo.org>
 <20140516183500.GI5379@htj.dyndns.org>
 <alpine.DEB.2.10.1405161350360.1681@gentwo.org>
 <20140516190042.GJ5379@htj.dyndns.org>
 <alpine.DEB.2.10.1405161431590.2126@gentwo.org>
 <CAOS58YPwkWQCtuE=sUReBzi+3ygvsawEovV-nfWLK2f3GDn9Kg@mail.gmail.com>
 <CAOS58YOTAEGP+=sgSGVDLW+X11QZ_s9jTyRwmpeUD9JQiWbjQQ@mail.gmail.com>
 <alpine.DEB.2.10.1405161802020.3336@gentwo.org>
 <20140516234850.GA15350@mtj.dyndns.org>
 <alpine.DEB.2.10.1405171745130.10418@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405171745130.10418@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, May 17, 2014 at 05:45:40PM -0500, Christoph Lameter wrote:
> On Fri, 16 May 2014, Tejun Heo wrote:
> 
> > > Make the uevent stuff work on all of sysfs?
> >
> > I don't know.  Maybe.  Likely a lot more work involving user space
> > changes tho.  Also, it runs contrary to what we've been doing to other
> > top-level cgroup directories.  Any reason not to do, say,
> > /sys/devices/kernel?
> 
> The other kernel tunables are in /sys/kernel.

Heh, we're talking past each other.  I meant moving everything under
/sys/kernel to /sys/devices/kernel and making /sys/kernel a symlink to
/sys/devices/kernel.

Thanks.

-- 
tejun
