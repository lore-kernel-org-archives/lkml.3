Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab3ILTsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:48:41 -0400
Received: from relay2.sgi.com ([192.48.179.30]:35227 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756600Ab3ILTsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:48:36 -0400
Date: Thu, 12 Sep 2013 20:48:33 +0100
From: Hedi Berriche <hedi@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dimitri Sivanich <sivanich@sgi.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] x86/UV: Add ability to disable UV NMI handler
Message-ID: <20130912194833.GW8742@dangermouse.emea.sgi.com>
Mail-Followup-To: Mike Travis <travis@sgi.com>, paulmck@linux.vnet.ibm.com,
	Peter Zijlstra <peterz@infradead.org>,
	Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Jason Wessel <jason.wessel@windriver.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dimitri Sivanich <sivanich@sgi.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <20130905225032.879120272@asylum.americas.sgi.com>
 <20130905225034.343366161@asylum.americas.sgi.com>
 <20130909124349.GY31370@twins.programming.kicks-ass.net>
 <522E0037.3090107@sgi.com>
 <20130910090349.GN26785@twins.programming.kicks-ass.net>
 <20130912172731.GR3966@linux.vnet.ibm.com>
 <52320F18.4040407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52320F18.4040407@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 19:59 Mike Travis wrote:
| On 9/12/2013 10:27 AM, Paul E. McKenney wrote:
|
| > But what is it that you are looking for?  If you want to silence it
| > completely, the rcu_cpu_stall_suppress boot/sysfs parameter is what
| > you want to use.
| 
| We have by default rcutree.rcu_cpu_stall_suppress=1 on the kernel
| cmdline.  I'll double check if it was set during my testing.

FWIW, for recent enough kernels the correct boot parameter is
rcupdate.rcu_cpu_stall_suppress.

It used to be rcutree.rcu_cpu_stall_suppress, but that has changed after
commit 6bfc09e.

Cheers,
Hedi.
-- 
Be careful of reading health books, you might die of a misprint.
	-- Mark Twain
