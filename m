Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaEAPJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:09:30 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:59775 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaEAPJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:09:29 -0400
Date: Thu, 1 May 2014 17:09:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/4] workqueue: Create low-level unbound workqueues
 cpumask
Message-ID: <20140501150918.GE25369@localhost.localdomain>
References: <1398350256-7834-1-git-send-email-fweisbec@gmail.com>
 <1398350256-7834-2-git-send-email-fweisbec@gmail.com>
 <20140424153716.GG14460@htj.dyndns.org>
 <20140501150114.GD25369@localhost.localdomain>
 <20140501150231.GD31611@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501150231.GD31611@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 11:02:31AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Thu, May 01, 2014 at 05:01:17PM +0200, Frederic Weisbecker wrote:
> > > Another thing with naming is that I didn't anticipate having
> > > attributes at the top directory so the workqueue directories aren't
> > > namespaced.  Maybe we want to namespace top level knobs?
> > > "system_cpumask" maybe?  Any better ideas?
> > 
> > Not sure why you want that. It makes sense on directories grouping
> > file for different subsystem. But here?
> 
> Worried about possible conflicts with workqueue names if we end up
> with more attributes.

But they are already protected in their own directories. Also having
the same file attribute names in root and in individual directories
suggests that root attributes primes on the childs.
