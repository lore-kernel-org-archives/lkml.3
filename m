Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760840Ab3DCDTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 23:19:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:8217 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759066Ab3DCDTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 23:19:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,397,1363158000"; 
   d="scan'208";a="312764395"
Message-ID: <515B9FC0.3040101@intel.com>
Date: Wed, 03 Apr 2013 11:19:28 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com
Subject: Re: [patch v3 3/8] sched: only count runnable avg on cfs_rq's nr_running
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <1364873008-3169-4-git-send-email-alex.shi@intel.com>
In-Reply-To: <1364873008-3169-4-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 11:23 AM, Alex Shi wrote:
> Old function count the runnable avg on rq's nr_running even there is
> only rt task in rq. That is incorrect, so correct it to cfs_rq's
> nr_running.

this patch is incorrect and removed in
	https://github.com/alexshi/power-scheduling.git runnablelb

