Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab3G2QOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:14:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:14346 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869Ab3G2QOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:14:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,770,1367996400"; 
   d="scan'208";a="353674085"
Date: Mon, 29 Jul 2013 23:57:31 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: Jeremy Eder <jeder@redhat.com>
Cc: linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com, riel@redhat.com,
        youquan.song@intel.com, youquan.song@linux.intel.com,
        paulmck@linux.vnet.ibm.com, daniel.lezcano@linaro.org,
        arjan@linux.intel.com, len.brown@intel.com
Subject: Re: RFC:  revert request for cpuidle patches e11538d1 and 69a37bea
Message-ID: <20130730035731.GA701@linux-youquan.bj.intel.com>
References: <20130726173306.GB17985@jeder.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726173306.GB17985@jeder.rdu.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

I try reproduce your result and then fix the issue, but I do not reproduce it
 yet.

I run at netperf-2.6.0 at one machine as server: netserver, other
machine: netperf -t TCP_RR -H $SERVER_IP -l 60. The target machine is
used in both client and server. I do not reproduce the performance drop
issue. I also notice the result is not stable, sometime it is high,
sometime is low. In sumarry, it is hard to make a definite result.

Can you try tell me how to reproduce the issue? how do you get the C0
data?

What's your config for kernel?  Do you enable CONFIG_NO_HZ_FULL=y or
only CONFIG_NO_HZ=y?


Thanks
-Youquan 
