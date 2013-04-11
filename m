Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934873Ab3DKROo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:14:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:39859 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934696Ab3DKROk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:14:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,456,1363158000"; 
   d="scan'208";a="320970725"
Message-ID: <5166EF74.4030106@linux.intel.com>
Date: Thu, 11 Apr 2013 10:14:28 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        Borislav Petkov <bp@alien8.de>, Kevin Hilman <khilman@linaro.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH documentation 1/2] nohz1: Add documentation.
References: <20130411160524.GA30384@linux.vnet.ibm.com> <1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +2.	Many architectures will place dyntick-idle CPUs into deep sleep
> +	states, which further degrades from-idle transition latencies.
> +
I think this part should just be deleted.
On x86, the deeper idle states are even used with non-tickless system (the break even times are
quite a bit less than even 1 msec).
I can't imagine that ARM is worse on this, at which point the statement above is highly dubious


