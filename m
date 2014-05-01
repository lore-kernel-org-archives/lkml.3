Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaEAOmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:42:06 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:50684 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaEAOmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:42:03 -0400
Date: Thu, 1 May 2014 10:41:58 -0400
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 2/4] workqueue: Split apply attrs code from its locking
Message-ID: <20140501144158.GB31611@htj.dyndns.org>
References: <1398350256-7834-1-git-send-email-fweisbec@gmail.com>
 <1398350256-7834-3-git-send-email-fweisbec@gmail.com>
 <20140424144832.GD14460@htj.dyndns.org>
 <20140501144018.GA25369@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501144018.GA25369@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 04:40:21PM +0200, Frederic Weisbecker wrote:
> > lockdep_assert_held()
> 
> Not sure... Only a small part of the function actually needs to be locked. Namely
> those doing the pwq allocations, which already have the lockdep_assert_held().

Ah, in that case, never mind.

Thanks.

-- 
tejun
