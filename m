Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaBJPbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:31:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbaBJPbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:31:35 -0500
Date: Mon, 10 Feb 2014 16:30:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Gautham R Shenoy <ego@linux.vnet.ibm.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, paulus@samba.org,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 01/51] CPU hotplug: Provide lockless versions of
	callback registration functions
Message-ID: <20140210153049.GA7507@redhat.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com> <20140206184103.GA31410@redhat.com> <20140207191125.GA8098@in.ibm.com> <52F898CB.6030900@linux.vnet.ibm.com> <20140210105130.GA14693@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210105130.GA14693@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10, Gautham R Shenoy wrote:
>
>  Add lockdep annotations for get/put_online_cpus() and
>  cpu_hotplug_begin()/cpu_hotplug_end().

Thanks, looks good.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

