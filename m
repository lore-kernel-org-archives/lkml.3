Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaEUTSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:18:55 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:57928 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaEUTSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:18:53 -0400
Date: Wed, 21 May 2014 15:18:50 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/5] workqueue: Allow changing attributions of ordered
 workqueues
Message-ID: <20140521191850.GD5259@htj.dyndns.org>
References: <1400257015-28222-1-git-send-email-fweisbec@gmail.com>
 <1400257015-28222-2-git-send-email-fweisbec@gmail.com>
 <537C55C4.70706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537C55C4.70706@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, May 21, 2014 at 03:29:08PM +0800, Lai Jiangshan wrote:
> Should we reorder the pwq_adjust_max_active() to avoid this declare?
> (Move pwq_adjust_max_active() to the place just before rcu_free_pwq())

Yeah, sure.  Sounds good to me.

Thanks.

-- 
tejun
