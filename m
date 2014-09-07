Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaIGLrT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 07:47:19 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34524 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaIGLrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 07:47:18 -0400
Date: Sun, 7 Sep 2014 14:47:13 +0300
From: Abel Vesa <abelvesa@gmail.com>
To: alex.shi@intel.com, vincent.guittot@linaro.org, peterz@infradead.org,
        pjt@google.com, efault@gmx.de, rjw@rjwysocki.net,
        morten.rasmussen@arm.com, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org, preeti@linux.vnet.ibm.com
Cc: linaro-kernel@lists.linaro.org, markgross@thegnar.org, corbet@lwn.net,
        catalin.marinas@arm.com, sundar.iyer@intel.com,
        linux-kernel@vger.kernel.org, mike.turquette@linaro.org,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        dietmar.eggemann@arm.com
Subject: Power Scheduler Design
Message-ID: <20140907114705.GA10470@abel-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a while now, I've started studying the power aware scheduling problem.
And like many other rookies out there I took all the lkml mails related
and read them all (well, almost all) and I saw that there are some
debating on the implementation.I even look over the implementation
proposed of Preeti U Murthy. I also worked (just for fun) for a while on
some ideas of my own (nothing worth sharing, yet) but I have problem
understanding the design requirements. Here is one. 

  Some of you (even Ingo) said  that the scheduler should be the one to
manage the cpu P/C states. In this case the governors of the cpuidle and
cpufreq would not make any sense anymore.  Does that mean they will not
be a part of this scheduling solution anymore?
