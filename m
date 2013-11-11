Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab3KKQlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:41:55 -0500
Received: from mga14.intel.com ([143.182.124.37]:37170 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab3KKQlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:41:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,679,1378882800"; 
   d="scan'208";a="425651569"
Message-ID: <52810876.2000402@linux.intel.com>
Date: Mon, 11 Nov 2013 08:40:22 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC: Vincent Guittot <vincent.guittot@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Tony Luck <tony.luck@intel.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>, l.majewski@samsung.com,
        Jonathan Corbet <corbet@lwn.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, linux-pm@vger.kernel.org
Subject: Re: [RFC][PATCH v5 00/14] sched: packing tasks
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org> <CAHkRjk69GNYtLGBSWCNcsCzkBHywKrD0qQQbNkJRpMbcdsCPyw@mail.gmail.com> <20131111163859.GE26898@twins.programming.kicks-ass.net>
In-Reply-To: <20131111163859.GE26898@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 8:38 AM, Peter Zijlstra wrote:
> Like the package C states on x86 -- for those to be effective the
> scheduler needs to pack tasks and keep entire packages idle for as long
> as possible.

"package" C states on x86 are not really per package... but system wide.
the name is very confusing.

